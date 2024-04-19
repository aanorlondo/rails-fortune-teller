class PredictionsController < ApplicationController
  before_action :save_user_information, only: [:create]
  before_action :load_user_information, only: %i[create rate show]

  # GET /predictions/
  def index
  end

  # POST /predictions/
  def create
    # Call OpenAI API with preset prompt using name, age, and zodiac sign
    @prediction = generate_prediction(@name, @age, @zodiac_sign)
    session[:prediction] = @prediction
    redirect_to predictions_show_path
  rescue StandardError => e
    flash.now[:error] = "OpenAPI Error: #{e.message}. Check your API Key and try again."
    render :index
  end

  # GET /predictions/show
  def show
    @prediction = session[:prediction]
  end

  # POST /predictions/rate
  def rate
    prediction_text = params[:prediction_text]
    rating = params[:rating]
    if rating == 'positive'
      anonymized_prediction_text = anonymize_prediction(prediction_text)
      Prediction.create(text: anonymized_prediction_text)
    end
    redirect_to root_path
  rescue StandardError => e
    flash.now[:error] = "Error: #{e.message}. Please try again later."
  end

  # GET /predictions/list
  def list
    @predictions = Prediction.paginate(page: params[:page], per_page: 5).order(created_at: :desc)
    render :list
  end

  private

  # OPENAI
  def generate_prediction(name, age, zodiac_sign)
    # populate prompt template with name, age, and zodiac sign
    prompt = ERB.new(OPENAI_CONFIG[:prompt]).result(binding)

    # instantiate openai object with api key from env variable
    openai = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

    # run the request and get the response
    response = openai.chat(
      parameters: {
        model: OPENAI_CONFIG[:model],
        messages: [{ role: 'user', content: prompt }],
        temperature: OPENAI_CONFIG[:temperature]
      }
    )
    response.dig('choices', 0, 'message', 'content')
  end

  # ANONYIMIZE
  def anonymize_prediction(prediction_text)
    anonymized_text = prediction_text.gsub(/#{@name.capitalize}/, 'xxxx')
    anonymized_text.gsub!(/#{@age}/, 'yyyy')
    anonymized_text.gsub!(/#{@zodiac_sign}/, 'zzzz')
    anonymized_text
  end

  # SESSION
  def save_user_information
    session[:user_name] = params[:name]
    session[:user_age] = params[:age]
    session[:user_zodiac_sign] = params[:zodiac_sign].split(' ').first
  end

  def load_user_information
    @name = session[:user_name]
    @age = session[:user_age]
    @zodiac_sign = session[:user_zodiac_sign]
  end
end

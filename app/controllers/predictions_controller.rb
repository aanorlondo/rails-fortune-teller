class PredictionsController < ApplicationController
  before_action :save_user_information, only: [:create]
  before_action :load_user_information, only: %i[create rate show]

  # /*********************
  #  * GET /PREDICTIONS/ *
  #  *********************/
  def index
  end

  # /**********************
  #  * POST /PREDICTIONS/ *
  #  **********************/
  def create
    # Call OpenAI API with preset prompt using name, age, and zodiac sign
    @prediction = generate_prediction(@name, @age, @zodiac_sign)
    session[:prediction] = @prediction
    session[:rated_positive] = false
    redirect_to predictions_show_path
  rescue StandardError => e
    flash.now[:error] = "OpenAPI Error: #{e.message}. Check your API Key and try again."
    render :index
  end

  # /*************************
  #  * GET /PREDICTIONS/SHOW *
  #  *************************/
  def show
    @prediction = session[:prediction]
  end

  # /****************************
  #  * # POST /PREDICTIONS/RATE *
  #  ****************************/
  def rate
    prediction_text = params[:prediction_text]
    rating = params[:rating]
    if rating == 'positive' && !session[:rated_positive]
      anonymized_prediction_text = anonymize_prediction(prediction_text)
      Prediction.create(text: anonymized_prediction_text)
      session[:rated_positive] = true
    end
    redirect_to root_path
  rescue StandardError => e
    flash.now[:error] = "Error: #{e.message}. Please try again later."
  end

  # /***************************
  #  * # GET /PREDICTIONS/LIST *
  #  ***************************/
  def list
    @predictions = Prediction.paginate(page: params[:page], per_page: 5).order(created_at: :desc)
    render :list
  end

  private

  # /**********
  #  * OPENAI *
  #  **********/
  def generate_prediction(name, age, zodiac_sign)
    # Populate prompt template with name, age, and zodiac sign
    prompt = ERB.new(OPENAI_CONFIG[:prompt]).result(binding)
    prompt = add_inspiration(prompt) unless inspiration?
    logger.info("INFO: user prompt: #{prompt}")

    # Run the request and get the response
    openai = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    response = openai.chat(
      parameters: {
        model: OPENAI_CONFIG[:model],
        messages: [{ role: 'user', content: prompt }],
        temperature: OPENAI_CONFIG[:temperature]
      }
    )
    response.dig('choices', 0, 'message', 'content')
  end

  # Add inspiration examples to the prompt
  def add_inspiration(prompt)
    inspiration_subprompt = ERB.new(OPENAI_CONFIG[:inspirations_subprompt]).result(binding)
    prompt += "\n#{inspiration_subprompt}\n"
    sample_size = rand(2..5)
    inspiration_samples = get_random_samples(sample_size)
    inspiration_samples.each_with_index do |sample, index|
      prompt += "- Exemple #{index + 1}: #{sample}\n"
    end
    prompt
  end

  # Check if inspiration should be included
  def inspiration?
    rand(1..10) <= 2 # 20% chance of inspiration being true
  end

  # Get random samples from the database
  def get_random_samples(sample_size)
    Prediction.order(Arel.sql('RANDOM()')).limit(sample_size).pluck(:text)
  end

  # /**************
  #  * ANONYIMIZE *
  #  **************/
  def anonymize_prediction(prediction_text)
    anonymized_text = prediction_text.gsub(/#{@name.capitalize}/, 'xxxx')
    anonymized_text.gsub!(/#{@age}/, 'yyyy')
    anonymized_text.gsub!(/#{@zodiac_sign}/, 'zzzz')
    anonymized_text
  end

  # /***********
  #  * SESSION *
  #  ***********/
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

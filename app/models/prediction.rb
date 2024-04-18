# app/models/prediction.rb
class Prediction < ApplicationRecord
  validates :text, presence: true
end

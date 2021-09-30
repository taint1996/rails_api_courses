class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user

  before_save :calculate_average_rating
  counter_culture :book

  def calculate_average_rating
    self.average_rating = ((self.content_rating.to_f + self.recommend_rating.to_f) / 2).round(1)
  end
end

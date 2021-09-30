class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user

  before_validation :parse_image
  before_save :calculate_average_rating

  counter_culture :book

  attr_accessor :image_review

  has_attached_file :picture, styles: { medium: '300x300>', thumb: '100x100>'}
  validates_attachment :picture, presence: true
  do_not_validate_attachment_file_type :picture

  private
    def parse_image
      image = Paperclip.io_adapters.for image_review
      image.original_filename = "review_img_#{Time.now.strftime("%Y%m%d_%H%M%S")}.jpg"
      self.picture = image
    end

  def calculate_average_rating
    self.average_rating = ((self.content_rating.to_f + self.recommend_rating.to_f) / 2).round(1)
  end
end

class Api::V1::ReviewsController < ApplicationController
  before_action :load_book, only: :index
  before_action :load_review, only: [:show, :update, :destroy]
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]

  def index
    @reviews = @book.reviews
    json_response "Index list Reviews successfully", true, { reviews: @reviews }, :ok
  end

  def show
    json_response "Show review successfully", true, { review: @review }, :ok
  end

  def create
    review = Review.new(review_params)
    review.user_id = current_user.id
    review.book_id = params[:book_id]

    if review.save
      json_response "Created review successfully", true, { review: review }, :ok
    else
      json_response "Failed to create review", false, {}, :unprocessable_entity
    end
  end

  def update
    if correct_user @review.user
      update_review(@review, review_params)
    else
      json_response "You don't have permission to do this", false, { review: @review }, :unauthorized
    end
  end

  def destroy
    if correct_user @review.user
      destroy_review(@review)
    else
      json_response "You don't have permission to do this", false, { review: @review }, :unauthorized
    end
  end

  private
    def load_book
      @book = Book.find_by(id: params[:book_id])

      unless @book.present?
        json_response "Cannot find a book", false, {}, :not_found
      end
    end

    def load_review
      @review = Review.find_by(id: params[:id])

      unless @review.present?
        json_response "Cannot find a review", false, {}, :not_found
      end
    end

    def review_params
      params.require(:review).permit(:title, :content_rating, :recommend_rating)
    end

    def update_review review, review_params
      if review.update review_params
        json_response "Updated review successfully", true, { review: review }, :ok
      else
        json_response "Failed to update a review", false, {}, :unprocessable_entity
      end
    end

    def destroy_review review
      if review.destroy
        json_response "Deleted review successfully", true, { review: review }, :ok
      else
        json_response "Failed to delete a review", false, {}, :unprocessable_entity
      end
    end
end
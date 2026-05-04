class Value < ApplicationRecord
  belongs_to :user
  belongs_to :image

  validates :value, presence: true,
                    numericality: { only_integer: true,
                                    greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 10 }

  validates :user_id, uniqueness: { scope: :image_id }

  after_save    :update_image_average
  after_destroy :update_image_average

  private

  def update_image_average
    image.recalculate_average!
  end
end
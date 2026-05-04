class Image < ApplicationRecord
  belongs_to :theme
  has_many :values, dependent: :destroy

  validates :name, presence: true
  validates :file, presence: true

  def recalculate_average!
    avg = values.average(:value)
    update_column(:ave_value, avg.to_f.round(2))
  end
end
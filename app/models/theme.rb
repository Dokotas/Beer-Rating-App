class Theme < ApplicationRecord
  has_many :images, dependent: :destroy
  validates :name, presence: true
  validates :key, presence: true, uniqueness: true

  def localized_name
    I18n.t("themes.names.#{key}", default: name)
  end
end
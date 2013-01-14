class Product < ActiveRecord::Base
  attr_accessible :description, :image_url, :price, :title
  validates :title, :description, :image_url, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true, length: {
      #minimum: 10,
      #maximum: 20,
      in: 6..20,
      too_long: "%{count} characters is the maximum allowed",
      too_short: "%{count} characters is the minimum allowed"
      #is:  6
      #message: "must be between 10 to 20 characters long."
  }, format: {
      with: /^[-!+\w\.\s\"\']+$/i,
      message: 'should only contain letters, numbers, whitespace, quotation marks or .-_!+'
  }
  validates :image_url, allow_blank: true, format: {
      with: %r{\.(gif|jpg|png)$}i,
      message: 'must be a URL for GIF, JPG or PNG image.'
  }
end

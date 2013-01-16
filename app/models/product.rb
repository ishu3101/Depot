class Product < ActiveRecord::Base
  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  private
  # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Items present')
      return false
    end
  end

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

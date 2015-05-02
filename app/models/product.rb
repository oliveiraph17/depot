class Product < ActiveRecord::Base
  validates_presence_of :title, :description, :image_url
  validates_uniqueness_of :title
  validates_format_of :image_url, {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.',
    allow_blank: true
  }
  validates_numericality_of :price, greater_than_or_equal_to: 0.01
end

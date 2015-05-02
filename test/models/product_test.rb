require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "product is not valid without a unique title" do
    product = Product.new(title:       products(:programming_ruby).title,
                          description: "Fred description.",
                          image_url:   "fred.gif",
                          price:       1)

    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end

  def new_product(image_url)
    Product.new(title:       "Title",
                description: "Description.",
                image_url:   image_url,
                price:       1)
  end

  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png http://a.b/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |url|
      assert new_product(url).valid?, "#{url} should be valid"
    end

    bad.each do |url|
      assert new_product(url).invalid?, "#{url} should not be valid"
    end
  end

  test "product price must be positive" do
    product = Product.new(title:       "Title",
                          description: "Description.",
                          image_url:   "xpto.jpg")

    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 1
    assert product.valid?
  end
end

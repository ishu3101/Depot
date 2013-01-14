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

  test "product price must be positive" do
    product = Product.new(title: "My Book Title", description: "yyy", image_url: "zzz.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')

    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')

    product.price = 1
    assert product.valid?
  end


  def new_product(image_url)
    Product.new(title: "My Book Title", description: "yyy", price: 1, image_url: image_url)
  end

  test "product image url must end with one of .jpg, .png, .gif" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end

  end

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title, description: "yyy", price: 1, image_url: "fred.gif")
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end

  def new_product_title(title)
    Product.new(title: title, description: "yyy", price: 1, image_url: "zzz.jpg")
  end

  test "product title must contain letters, numbers, whitespace, quotation marks or .-_!+" do
    ok = ["1-d!_-1+", "a!.5 78ABCS!.", "1sD.2 !3-2d", "-3f_+dF", "'a!B21-0+ +-'", "\"9874445\""]
    bad = ["@1-d!_-1+", "Book", "1sD.2$!3-2d", "-3f_+ dF~", "'a!B223Ss! fSQ241-0+ +-'", "\"9\A.how@areyou874445\""]
    ok.each do |name|
      assert new_product_title(name).valid?, "#{name} shouldn't be invalid"
    end
    bad.each do |name|
      assert new_product_title(name).invalid?, "#{name} shouldn't be valid"
    end
  end
end
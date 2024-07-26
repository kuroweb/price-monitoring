require "rails_helper"

RSpec.describe Product, type: :model do
  it "validates presence of name" do
    product = Product.new
    product.valid?
    expect(product.errors[:name]).to include("can't be blank")
  end

  # Add more test cases as needed
end

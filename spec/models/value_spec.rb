require "rails_helper"

RSpec.describe Value, type: :model do
  let(:theme) { Theme.create!(name: "Test") }
  let(:image) { Image.create!(name: "Beer", file: "x.avif", theme: theme, ave_value: 0) }
  let(:user) {
    User.create!(name: "U", email: "u@e.com",
                 password: "password", password_confirmation: "password")
  }

  it "is valid with value in 1..10" do
    expect(Value.new(user: user, image: image, value: 5)).to be_valid
  end

  it "rejects value above 10" do
    expect(Value.new(user: user, image: image, value: 11)).not_to be_valid
  end

  it "rejects value below 1" do
    expect(Value.new(user: user, image: image, value: 0)).not_to be_valid
  end

  it "rejects non-integer values" do
    expect(Value.new(user: user, image: image, value: 5.5)).not_to be_valid
  end

  it "updates image average after save" do
    Value.create!(user: user, image: image, value: 8)
    expect(image.reload.ave_value).to eq(8.0)
  end

  it "recalculates average from multiple users" do
    user2 = User.create!(name: "U2", email: "u2@e.com",
                         password: "password", password_confirmation: "password")
    Value.create!(user: user,  image: image, value: 6)
    Value.create!(user: user2, image: image, value: 10)
    expect(image.reload.ave_value).to eq(8.0)
  end

  it "enforces uniqueness per (user, image)" do
    Value.create!(user: user, image: image, value: 5)
    dup = Value.new(user: user, image: image, value: 7)
    expect(dup).not_to be_valid
  end
end
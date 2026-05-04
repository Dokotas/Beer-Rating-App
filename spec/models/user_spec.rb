require "rails_helper"

RSpec.describe User, type: :model do
  let(:valid_attrs) {
    { name: "Иван",
      email: "ivan@example.com",
      password: "password",
      password_confirmation: "password" }
  }

  it "valid with correct attributes" do
    expect(User.new(valid_attrs)).to be_valid
  end

  it "invalid without name" do
    expect(User.new(valid_attrs.merge(name: ""))).not_to be_valid
  end

  it "invalid with bad email format" do
    expect(User.new(valid_attrs.merge(email: "not-an-email"))).not_to be_valid
  end

  it "rejects short password" do
    short = valid_attrs.merge(password: "x", password_confirmation: "x")
    expect(User.new(short)).not_to be_valid
  end

  it "rejects duplicate email (case-insensitive)" do
    User.create!(valid_attrs)
    dup = User.new(valid_attrs.merge(name: "Other", email: "IVAN@EXAMPLE.COM"))
    expect(dup).not_to be_valid
  end

  it "downcases email before save" do
    user = User.create!(valid_attrs.merge(email: "MIXED@Case.COM"))
    expect(user.email).to eq("mixed@case.com")
  end

  it "creates remember_token before save" do
    user = User.create!(valid_attrs)
    expect(user.remember_token).to be_present
  end

  it "authenticates with correct password" do
    user = User.create!(valid_attrs)
    expect(user.authenticate("password")).to eq(user)
  end

  it "rejects authentication with wrong password" do
    user = User.create!(valid_attrs)
    expect(user.authenticate("wrong")).to be_falsey
  end
end
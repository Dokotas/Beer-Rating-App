require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let!(:user) {
    User.create!(name: "X", email: "x@e.com",
                 password: "password", password_confirmation: "password")
  }

  describe "GET /signin" do
    it "returns 200 OK" do
      get "/signin"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /signin" do
    it "redirects on valid credentials" do
      post "/signin", params: { session: { email: "x@e.com", password: "password" } }
      expect(response).to redirect_to(root_path)
    end

    it "renders new on invalid password" do
      post "/signin", params: { session: { email: "x@e.com", password: "wrong" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "is case-insensitive for email" do
      post "/signin", params: { session: { email: "X@E.COM", password: "password" } }
      expect(response).to redirect_to(root_path)
    end
  end

  describe "DELETE /signout" do
    it "redirects to root" do
      delete "/signout"
      expect(response).to redirect_to(root_path)
    end
  end
end
require "./spec_helper"

def default_user_hash
  {"password" => "qwertyuiop", "password_confirmation" => "qwertyuiop", "email" => "fake@fake.com", "nickname" => "Fake"}
end

def user_params(user_hash : Hash(String, String))
  params = [] of String
  params << "email=#{user_hash["email"]}"
  params << "password=#{user_hash["password"]}"
  params << "password_confirmation=#{user_hash["password_confirmation"]}"
  params << "nickname=#{user_hash["nickname"]}"
  params.join("&")
end

def create_user
  model = User.new(default_user_hash)
  model.save
  model
end

class UserControllerTest < GarnetSpec::Controller::Test
  getter handler : Amber::Pipe::Pipeline

  def initialize
    @handler = Amber::Pipe::Pipeline.new
    @handler.build :api do
      plug Amber::Pipe::Error.new
      plug Amber::Pipe::Session.new
    end
    @handler.build :public_api do
      plug Amber::Pipe::Error.new
      plug Amber::Pipe::Session.new
    end
    @handler.prepare_pipelines
  end
end

describe UserControllerTest do
  subject = UserControllerTest.new

  describe "#index" do
    it "renders user index" do
      User.clear
      response = subject.get "/users"

      response.status_code.should eq(200)
      response.body.should contain("[]")
    end

    describe "with a q param" do
      it "returns matching users" do
        user1 = User.create(email: "fake1@test.fr", nickname: "foobar")
        user2 = User.create(email: "fake2@test.fr", nickname: "bar")
        response = subject.get "/users?q=foo"

        response.status_code.should eq(200)
        response.body.should contain([user1].to_json)
      end
    end
  end

  describe "#show" do
    it "renders user show" do
      User.clear
      model = create_user
      location = "/users/#{model.id}"

      response = subject.get location

      response.status_code.should eq(200)
      response.body.should contain(model.to_json)
    end
  end

  describe "#create" do
    it "creates a user" do
      User.clear
      response = subject.post "/auth/sign_up", body: user_params(default_user_hash)

      response.status_code.should eq(201)
    end

    describe "when email and password are already taken" do
      it "returns errors" do
        User.clear
        create_user
        response = subject.post "/auth/sign_up", body: user_params(default_user_hash)
        errors = {errors: [{email: "Email already in use"}, {nickname: "Nickname already in use"}]}

        response.status_code.should eq(403)
        response.body.should eq(errors.to_json)
      end
    end

    describe "when the passwords are different" do
      it "returns errors" do
        User.clear
        hash = default_user_hash.merge({"password_confirmation" => "qwertyuio"})
        response = subject.post "/auth/sign_up", body: user_params(hash)
        errors = {errors: [{password: "Passwords don't match"}]}

        response.status_code.should eq(403)
        response.body.should eq(errors.to_json)
      end
    end

    describe "when the password is too short" do
      it "returns errors" do
        User.clear
        hash = default_user_hash.merge({"password" => "qwerty", "password_confirmation" => "qwerty"})
        response = subject.post "/auth/sign_up", body: user_params(hash)
        errors = {errors: [{password: "Password is too short"}]}

        response.status_code.should eq(403)
        response.body.should eq(errors.to_json)
      end
    end
  end

  describe "#update" do
    it "updates a user" do
      User.clear
      model = create_user
      response = subject.patch "/users/#{model.id}", body: user_params(default_user_hash)

      response.status_code.should eq(200)
    end
  end

  describe "#delete" do
    it "deletes a user" do
      User.clear
      model = create_user
      response = subject.delete "/users/#{model.id}"

      response.status_code.should eq(204)
    end
  end
end

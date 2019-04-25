require "./spec_helper"

def user_hash
  {"password" => "qwertyuiop", "email" => "fake@fake.com", "nickname" => "Fake"}
end

def user_params
  params = [] of String
  params << "email=#{user_hash["email"]}"
  params << "password=#{user_hash["password"]}"
  params << "password_confirmation=#{user_hash["password"]}"
  params << "nickname=#{user_hash["nickname"]}"
  params.join("&")
end

def create_user
  model = User.new(user_hash)
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
      response = subject.post "/auth/sign_up", body: user_params

      response.status_code.should eq(201)
    end
  end

  describe "#update" do
    it "updates a user" do
      User.clear
      model = create_user
      response = subject.patch "/users/#{model.id}", body: user_params

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

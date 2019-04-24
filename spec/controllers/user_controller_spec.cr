require "./spec_helper"

def user_hash
  {"password" => "Fake", "email" => "Fake", "nickname" => "Fake"}
end

def user_params
  params = [] of String
  params << "password=#{user_hash["password"]}"
  params << "email=#{user_hash["email"]}"
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
      plug Amber::Pipe::Flash.new
    end
    @handler.prepare_pipelines
  end
end

describe UserControllerTest do
  subject = UserControllerTest.new

  it "renders user index template" do
    User.clear
    response = subject.get "/users"

    response.status_code.should eq(200)
    response.body.should contain("[]")
  end

  it "renders user show template" do
    User.clear
    model = create_user
    location = "/users/#{model.id}"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain(model.to_json)
  end

  it "creates a user" do
    User.clear
    response = subject.post "/users", body: user_params

    response.status_code.should eq(200)
  end

  it "updates a user" do
    User.clear
    model = create_user
    response = subject.patch "/users/#{model.id}", body: user_params

    response.status_code.should eq(200)
  end

  it "deletes a user" do
    User.clear
    model = create_user
    response = subject.delete "/users/#{model.id}"

    response.status_code.should eq(200)
  end
end

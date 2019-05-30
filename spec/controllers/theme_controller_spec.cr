require "./spec_helper"

def theme_hash
  {"title" => "Disney musics", "description" => "A collection of Disney musics"}
end

def default_theme_hash
  {"title" => "Fake Music", "description" => "A collection of Fake musics"}
end

def theme_params(hash)
  params = [] of String
  params << "title=#{hash["title"]}"
  params << "description=#{hash["description"]}"
  params.join("&")
end

def create_theme(hash)
  model = Theme.new(hash)
  model.save
  model
end

class ThemeControllerTest < GarnetSpec::Controller::Test
  getter handler : Amber::Pipe::Pipeline

  def initialize
    @handler = Amber::Pipe::Pipeline.new
    @handler.build :api do
      plug Amber::Pipe::Error.new
      # plug Amber::Pipe::Session.new
    end
    @handler.prepare_pipelines
  end
end

describe ThemeControllerTest do
  subject = ThemeControllerTest.new

  describe "#index" do
    it "renders theme index" do
      Theme.clear
      response = subject.get "/themes"

      response.status_code.should eq(200)
      response.body.should contain("[]")
    end
  end

  describe "#show" do
    it "renders theme show" do
      Theme.clear
      model = create_theme(theme_hash)
      location = "/themes/#{model.id}"

      response = subject.get location

      response.status_code.should eq(200)
      response.body.should contain(model.to_json)
    end
  end

  describe "#create" do
    it "creates a theme" do
      Theme.clear
      response = subject.post "/themes", body: theme_params(default_theme_hash)

      response.status_code.should eq(201)
      json = JSON.parse(response.body)
      (json["title"]).should eq(default_theme_hash["title"])
      (json["description"]).should eq(default_theme_hash["description"])
    end
  end

  describe "#update" do
    it "updates a theme" do
      Theme.clear
      model = create_theme(theme_hash)
      response = subject.patch "/themes/#{model.id}", body: theme_params(default_theme_hash)

      response.status_code.should eq(200)
      json = JSON.parse(response.body)
      (json["id"]).should eq(model.id)
      (json["title"]).should eq(default_theme_hash["title"])
      (json["description"]).should eq(default_theme_hash["description"])
    end
  end

  describe "#delete" do
    it "deletes a theme" do
      Theme.clear
      model = create_theme(theme_hash)
      response = subject.delete "/themes/#{model.id}"

      response.status_code.should eq(204)
      response.body.should eq("")
    end
  end
end

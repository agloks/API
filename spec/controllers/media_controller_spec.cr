require "./spec_helper"

def media_hash
  {"title" => "Fake", "kind" => "picture"}
end

def default_media_hash
  {"title" => "Cat picture", "kind" => "picture"}
end

def media_params
  params = [] of String
  params << "title=#{media_hash["title"]}"
  params << "kind=#{media_hash["kind"]}"
  params.join("&")
end

def create_picture
  model = Picture.new(media_hash)
  model.save
  model
end

class MediaControllerTest < GarnetSpec::Controller::Test
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

describe MediaControllerTest do
  subject = MediaControllerTest.new

  describe "#index" do
    it "renders media index" do
      Media.clear
      model = create_picture
      response = subject.get "/medias"

      response.status_code.should eq(200)
      response.body.should contain([model].to_json)
    end
  end

  describe "#show" do
    it "renders media show" do
      Media.clear
      model = create_picture
      location = "/medias/#{model.id}"

      response = subject.get location

      response.status_code.should eq(200)
      response.body.should contain(model.to_json)
    end
  end

  describe "#create" do
    it "creates a media" do
      Media.clear
      response = subject.post "/medias", body: media_params

      response.status_code.should eq(201)
      json = JSON.parse(response.body)
      (json["title"]).should eq(media_hash["title"])
      (json["kind"]).should eq(media_hash["kind"])
    end

    describe "with an unknown kind" do
      it "returns an error" do
        Media.clear
        response = subject.post "/medias", body: media_params + "foo"

        response.status_code.should eq(403)
        json = JSON.parse(response.body)
        (json["errors"][0]["kind"]).should eq("Unknown media kind")
      end
    end
  end

  describe "#delete" do
    it "deletes a media" do
      Media.clear
      model = create_picture
      response = subject.delete "/medias/#{model.id}"

      response.status_code.should eq(204)
      response.body.should eq("")
    end
  end
end

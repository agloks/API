require "./spec_helper"

def lobby_params(lobby_hash : Hash(Symbol, String))
  params = [] of String
  lobby_hash.each do |key, value|
    params << "#{key}=#{value}"
  end
  params.join("&")
end

class LobbyControllerTest < GarnetSpec::Controller::Test
  getter handler : Amber::Pipe::Pipeline

  def initialize
    @handler = Amber::Pipe::Pipeline.new
    @handler.build :api do
      plug Amber::Pipe::Error.new
    end
    @handler.prepare_pipelines
  end
end

describe LobbyControllerTest do
  Spec.before_each do
    Lobby.clear
    Theme.clear
  end

  subject = LobbyControllerTest.new

  describe "#index" do
    it "shows lobbies of a theme" do
      theme1 = Theme.create(title: "theme 1")
      theme2 = Theme.create(title: "theme 2")
      lobby1 = Lobby.create(theme_id: theme1.id, restricted: false, questions: 5, active: true)
      lobby2 = Lobby.create(theme_id: theme2.id, restricted: true, questions: 10, active: true)
      lobby3 = Lobby.create(theme_id: theme1.id, restricted: false, questions: 5, active: false)
      response = subject.get "/lobbies"

      response.status_code.should eq(200)
      response.body.should contain([lobby1].to_json)
    end
  end

  describe "#show" do
    it "shows a lobby" do
      theme = Theme.create(title: "qwekjh")
      lobby = Lobby.create(theme_id: theme.id, restricted: true, questions: 10)
      response = subject.get "/lobbies/#{lobby.id}"

      response.status_code.should eq(200)
      response.body.should contain(lobby.to_json)
    end
  end

  describe "#create" do
    it "create a lobby" do
      theme = Theme.create(title: "qwekjh")
      params = {:theme_id => theme.id.to_s, :restricted => "true", :questions => "10"}
      response = subject.post "/lobbies", body: lobby_params(params)

      response.status_code.should eq(201)
      json = JSON.parse(response.body)
      (json["theme_id"]).should eq(theme.id)
      (json["questions"]).should eq(10)
      (json["restricted"]).should eq(true)
    end
  end

  describe "#delete" do
    it "deletes a lobby" do
      lobby = Lobby.create(active: true, restricted: false, questions: 10)
      response = subject.delete "/lobbies/#{lobby.id}"

      response.status_code.should eq(204)
    end
  end
end

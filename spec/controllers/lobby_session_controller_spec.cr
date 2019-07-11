require "./spec_helper"

def lobby_params(lobby_hash : Hash(Symbol, String))
  params = [] of String
  lobby_hash.each do |key, value|
    params << "#{key}=#{value}"
  end
  params.join("&")
end

class LobbySessionControllerTest < GarnetSpec::Controller::Test
  getter handler : Amber::Pipe::Pipeline

  def initialize
    @handler = Amber::Pipe::Pipeline.new
    @handler.build :api do
      plug Amber::Pipe::Error.new
    end
    @handler.prepare_pipelines
  end
end

describe LobbySessionControllerTest do
  Spec.before_each do
    Lobby.clear
    User.clear
  end

  subject = LobbySessionControllerTest.new

  describe "#index" do
    it "shows lobbies of a theme" do
      lobby1 = Lobby.create(restricted: false, questions: 5, active: true)
      lobby2 = Lobby.create(restricted: false, questions: 5, active: true)
      user1 = User.create(nickname: "wertyu", email: "test1@test.fr", lobby_id: lobby1.id)
      user2 = User.create(nickname: "wertwyu", email: "test2@test.fr", lobby_id: lobby1.id)
      user3 = User.create(nickname: "wertdyu", email: "test3@test.fr", lobby_id: lobby2.id)
      response = subject.get "/lobbies/#{lobby1.id}/users"

      response.status_code.should eq(200)
      response.body.should contain([user2, user1].to_json)
    end
  end
end

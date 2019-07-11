require "./spec_helper"

class MessageControllerTest < GarnetSpec::Controller::Test
  getter handler : Amber::Pipe::Pipeline

  def initialize
    @handler = Amber::Pipe::Pipeline.new
    @handler.build :api do
      plug Amber::Pipe::Error.new
    end
    @handler.prepare_pipelines
  end
end

describe MessageControllerTest do
  Spec.before_each do
    Lobby.clear
    Message.clear
  end

  subject = MessageControllerTest.new

  describe "#index" do
    it "shows questions of a media" do
      lobby1 = Lobby.create(restricted: false, active: true)
      lobby2 = Lobby.create(restricted: false, active: true)
      message1 = Message.create(content: "qwerty", lobby_id: lobby1.id)
      message2 = Message.create(content: "asdfghj", lobby_id: lobby1.id)
      message3 = Message.create(content: "ldsjflkj", lobby_id: lobby2.id)
      response = subject.get "/lobbies/#{lobby1.id}/messages"

      response.status_code.should eq(200)
      response.body.should contain([message1, message2].to_json)
    end
  end
end

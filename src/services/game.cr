require "http/web_socket"

class GameService
  def initialize(@lobby : Lobby)
    @ws = HTTP::WebSocket.new(URI.parse("ws://localhost:3000/chat"))
    @topic = "chat_room:lobby_#{@lobby.id}"
  end

  def run
    medias = Media.where(theme_id: @lobby.theme.id).select.shuffle[0...@lobby.questions]
    @ws.send(join_message)
    medias.each do |media|
      @ws.send(message(media.title))
      15.times do |time|
        sleep 1
        @ws.send(message(time))
      end
    end

    @ws.send(leave_message)
    @ws.close
  end

  def join_message
    JSON.build do |json|
      json.object do
        json.field "event", "join"
        json.field "topic", @topic
      end
    end
  end

  def message(content)
    JSON.build do |json|
      json.object do
        json.field "event", "message"
        json.field "topic", @topic
        json.field "content", content
        json.field "source", "game"
      end
    end
  end

  def leave_message
    JSON.build do |json|
      json.object do
        json.field "event", "leave"
        json.field "topic", @topic
      end
    end
  end
end

class ChatRoomChannel < Amber::WebSockets::Channel
  def handle_joined(client_socket, message)
    "joined"
  end

  def handle_message(client_socket, message)
    lobby_id = message["topic"].to_s.split(":lobby_")[1]
    user_id = ::Auth::JWTService.new.decode(message["JWT"].to_s)[0]["user_id"].to_s
    Message.create(content: message["content"].to_s, lobby_id: lobby_id, user_id: user_id)
    string = JSON.build do |json|
      json.object do
        json.field "event", "message"
        json.field "topic", message["topic"].to_s
        json.field "content", message["content"].to_s
        json.field "user_id", user_id
      end
    end
    rebroadcast!(JSON.parse(string))
  end

  def handle_leave(client_socket)
    pp "leave"
  end
end

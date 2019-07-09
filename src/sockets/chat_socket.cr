struct ChatSocket < Amber::WebSockets::ClientSocket
  channel "chat_room:*", ChatRoomChannel

  def on_connect
    # returning true accept all connections
    # you can use authentication here
    pp "qwlkejwqk"
    true
  end
end

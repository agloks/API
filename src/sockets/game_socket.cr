struct GameSocket < Amber::WebSockets::ClientSocket
  channel "game_room:*", GameRoomChannel

  def on_connect
    # do some authentication here
    # return true or false, if false the socket will be closed
    true
  end
end

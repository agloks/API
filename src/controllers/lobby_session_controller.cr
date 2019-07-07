class LobbySessionController < ApplicationController
  getter lobby = Lobby.new
  getter user = User.new

  before_action do
    only [:create] { set_lobby }
  end

  def create
    if lobby.restricted && (!params["private_key"]? || params["private_key"] != lobby.private_key)
      respond_with(403) do
        json({errors: {private_key: "Wrong private key"}}.to_json)
      end
    else
      user.update lobby_id: lobby.id
      respond_with do
        json(user.to_json)
      end
    end
  end

  private def set_lobby
    @lobby = Lobby.find! params[:id]
    @user = User.find! session["current_user_id"]
  end
end

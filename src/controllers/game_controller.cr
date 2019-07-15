class GameController < ApplicationController
  getter lobby = Lobby.new

  before_action do
    only [:create] { set_lobby }
  end

  def create
    if params["lobby_id"] == nil
      respond_with(403) do
        json({errors: [{lobby_id: "Missing params"}]}.to_json)
      end
    else
      GameService.new(lobby).run
      respond_with do
        json("Fin de la partie")
      end
    end
  end

  private def set_lobby
    @lobby = Lobby.find! params[:lobby_id]
  end
end

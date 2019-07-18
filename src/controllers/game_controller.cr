class GameController < ApplicationController
  getter lobby = Lobby.new

  before_action do
    only [:create] { set_lobby }
  end

  def create
    GameService.new(lobby)
      .run
      .fmap(handle_success(201))
      .value_or(handle_error)
  end

  private def set_lobby
    @lobby = Lobby.find! params[:id]
  end

  private def handle_success(code)
    ->(game : Game) do
      respond_with(code) do
        json game.to_json
      end
    end
  end
end

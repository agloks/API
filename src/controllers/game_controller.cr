class GameController < ApplicationController
  getter lobby = Lobby.new

  before_action do
    only [:create] { set_lobby }
  end

  def create
    GameService.new(lobby).run
    respond_with do
      json ""
    end
  end

  private def set_lobby
    @lobby = Lobby.find! params[:id]
  end
end

class LobbyController < ApplicationController
  getter lobby = Lobby.new

  before_action do
    only [:show, :destroy] { set_lobby }
  end

  def index
    lobbies = Lobby.where(restricted: false, active: true).select
    respond_with do
      json lobbies.to_json
    end
  end

  def show
    respond_with do
      json lobby.to_json
    end
  end

  def create
    lobby = Lobby.new(creation_lobby_params.validate!)
    lobby.created_by = session["current_user_id"].try(&.to_i)
    lobby.active = true
    if lobby.save
      respond_with(201) do
        json lobby.to_json
      end
    else
      respond_with(403) do
        json({errors: formatted_errors(lobby)}.to_json)
      end
    end
  end

  def destroy
    lobby.active = false
    if lobby.save
      respond_with(204) do
        json ""
      end
    else
      respond_with(403) do
        json({errors: formatted_errors(lobby)}.to_json)
      end
    end
  end

  private def creation_lobby_params
    params.validation do
      required :theme_id
      required :questions
      required :restricted
    end
  end

  private def set_lobby
    @lobby = Lobby.find! params[:id]
  end
end

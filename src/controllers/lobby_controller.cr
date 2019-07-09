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
    Factory::Lobby.new(creation_lobby_params.validate!, session["current_user_id"])
      .build
      .bind(save_lobby)
      .fmap(handle_success(201))
      .value_or(handle_error)
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

  private def save_lobby
    ->(lobby : Lobby) do
      if lobby.save
        Monads::Right.new(lobby)
      else
        Monads::Left.new(formatted_errors(lobby))
      end
    end
  end

  private def handle_success(code)
    ->(lobby : Lobby) do
      respond_with(code) do
        json lobby.to_json
      end
    end
  end
end

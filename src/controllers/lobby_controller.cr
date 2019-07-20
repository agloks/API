class LobbyController < ApplicationController
  getter lobby = Lobby.new

  before_action do
    only [:show, :destroy] { set_lobby }
  end

  def index
    lobbies = get_lobbies(params)

    themes = Theme.where(id: lobbies.each_with_object([] of Int32) { |lobby, array| array.push lobby.theme_id! }).select
    string = JSON.build do |json|
      json.array do
        lobbies.each do |lobby|
          theme = themes.select { |t| t.id == lobby.theme_id }.first
          pp theme
          json.object do
            json.field "id", lobby.id
            json.field "restricted", lobby.restricted
            json.field "active", lobby.active
            json.field "questions", lobby.questions
            json.field "created_at", lobby.created_at
            json.field "updated_at", lobby.updated_at
            json.field "created_by", lobby.created_by
            json.field "theme" do
              json.object do
                json.field "id", lobby.theme_id
                json.field "title", theme.title
                json.field "description", theme.description
              end
            end
          end
        end
      end
    end

    respond_with do
      json string
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

  private def get_lobbies(params)
    if params["score"]?
      query = "JOIN games ON lobbies.id = games.lobby_id \
        JOIN scores ON games.id = scores.game_id \
        GROUP BY lobbies.id"
      Lobby.all(query)
    else
      Lobby.where(restricted: false, active: true).select
    end
  end
end

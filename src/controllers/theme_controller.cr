class ThemeController < ApplicationController
  getter theme = Theme.new

  before_action do
    only [:show, :update, :destroy] { set_theme }
  end

  def index
    current_user = User.find(session["current_user_id"])
    respond_with do
      json get_themes(current_user.not_nil!, params["public"]?).to_json
    end
  end

  def show
    respond_with do
      json theme.to_json
    end
  end

  def create
    theme = Theme.new theme_params.validate!
    theme.user_id = session[:current_user_id].try(&.to_i)
    if theme.save
      respond_with(201) do
        json theme.to_json
      end
    else
      respond_with(403) do
        json({errors: formatted_errors(theme)}.to_json)
      end
    end
  end

  def update
    theme.set_attributes theme_params.validate!
    if theme.save
      respond_with do
        json theme.to_json
      end
    else
      respond_with(403) do
        json({errors: formatted_errors(theme)}.to_json)
      end
    end
  end

  def destroy
    theme.destroy
    Lobby.where(theme_id: theme.id).select.each { |l| l.update(active: false) }
    respond_with(204) do
      json ""
    end
  end

  private def theme_params
    params.validation do
      required :title
      required :description
    end
  end

  private def set_theme
    @theme = Theme.find! params[:id]
  end

  private def get_themes(user, public?)
    user.admin? || public? ? Theme.all : Theme.where(user_id: user.id).select
  end
end

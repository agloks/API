class UserController < ApplicationController
  getter user = User.new

  before_action do
    only [:show, :update, :destroy] { set_user }
  end

  def index
    if params["q"]?
      users = User.all("WHERE nickname LIKE ?", ["%#{params["q"]}%"])
    else
      users = User.all
    end
    respond_with do
      json users.to_json
    end
  end

  def show
    respond_with do
      json user.to_json
    end
  end

  def create
    Factory::User.new(user_params.validate!)
      .build
      .bind(save_user)
      .fmap(handle_success(201))
      .value_or(handle_error)
  end

  def update
    user.set_attributes update_user_params.validate!
    result = user.save ? user.to_json : {errors: formatted_errors(user)}.to_json
    respond_with do
      json result
    end
  end

  def destroy
    user.destroy
    respond_with(204) do
      json ""
    end
  end

  private def user_params
    params.validation do
      required :password
      required :password_confirmation
      required :email { |p| p.email? }
      required :nickname
      optional :rank
    end
  end

  private def update_user_params
    params.validation do
      optional :email { |p| p.email? }
      optional :nickname
      optional :status
    end
  end

  private def set_user
    @user = User.find! params[:id]
  end

  private def save_user
    ->(user : User) do
      if user.save
        Monads::Right.new(user)
      else
        Monads::Left.new(formatted_errors(user))
      end
    end
  end

  private def handle_success(code)
    ->(user : User) do
      respond_with(code) do
        json user.to_json
      end
    end
  end
end

class UserController < ApplicationController
  getter user = User.new

  before_action do
    only [:show, :update, :destroy] { set_user }
  end

  def index
    users = User.all
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
    Auth::UserFactory.new(user_params.validate!)
      .build
      .bind(save_user)
      .fmap(handle_success(201))
      .value_or(handle_error)
  end

  def update
    user.set_attributes user_params.validate!
    result = user.save ? user.to_json : {error: "NOPE"}.to_json
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
        Monads::Left.new(user.errors.map { |error| {error.field.to_s => error.message.to_s} })
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

  private def handle_error
    ->(errors : Array(Hash(String, String))) do
      respond_with(403) do
        json({errors: errors}.to_json)
      end
    end
  end
end

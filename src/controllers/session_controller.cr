class SessionController < ApplicationController
  def create
    user = User.find_by(email: auth_params[:email])

    if user
      if Crypto::Bcrypt::Password.new(user.password || "") == auth_params[:password]
        session[:current_user_id] = user.id
        respond_with do
          json({"token":   Auth::JWTService.new.encode({user_id: user.id}),
                "user_id": user.id}.to_json)
        end
      else
        respond_with(403) do
          json({"error": "wrong password"}.to_json)
        end
      end
    else
      respond_with(403) do
        json({"error": "email doesn't exist"}.to_json)
      end
    end
  end

  def delete
    session.delete(:current_user_id)
    respond_with(204) do
      json ""
    end
  end

  private def auth_params
    params.validation do
      required(:email) { |p| p.email? }
      required(:password)
    end
  end
end

class FriendshipController < ApplicationController
  INDEX_FINDER = {
    nil        => ->(repo : Query::Friendships) { repo.all },
    "accepted" => ->(repo : Query::Friendships) { repo.accepted },
    "pending"  => ->(repo : Query::Friendships) { repo.pending },
    "sent"     => ->(repo : Query::Friendships) { repo.sent },
  }

  getter friendship = Friendship.new

  before_action do
    only [:update] { set_friendship }
  end

  def index
    if action = INDEX_FINDER[params["status"]?]?
      repository = Query::Friendships.new(session["current_user_id"].not_nil!)

      respond_with do
        json action.call(repository).to_json
      end
    else
      respond_with(400) do
        json({errors: {status: "Unhandled status"}}.to_json)
      end
    end
  end

  def create
    Factory::Friendship.new(creation_friendship_params.validate!, session["current_user_id"].not_nil!)
      .build
      .bind(save_friendship)
      .fmap(handle_success(201))
      .value_or(handle_error)
  end

  def update
    friendship.set_attributes update_friendship_params.validate!
    if friendship.save
      respond_with do
        json friendship.to_json
      end
    else
      respond_with(403) do
        json({errors: formatted_errors(friendship)}.to_json)
      end
    end
  end

  private def creation_friendship_params
    params.validation do
      required :asked_to
    end
  end

  private def update_friendship_params
    params.validation do
      required :status
    end
  end

  private def set_friendship
    @friendship = Friendship.find! params[:id]
  end

  private def save_friendship
    ->(friendship : Friendship) do
      if friendship.save
        Monads::Right.new(friendship)
      else
        Monads::Left.new(formatted_errors(friendship))
      end
    end
  end

  private def handle_success(code)
    ->(friendship : Friendship) do
      respond_with(code) do
        json friendship.to_json
      end
    end
  end
end

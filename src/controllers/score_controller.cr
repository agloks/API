class ScoreController < ApplicationController
  def index
    query = "JOIN games_users gu ON gu.user_id = users.id \
      JOIN games ON gu.game_id = games.id \
      WHERE games.lobby_id = ?"
    users = User.all(query, [params["id"]]).each_with_object({} of Int64 => String) do |user, hash|
      hash[user.id.not_nil!] = user.nickname.not_nil!
    end

    query = "JOIN games ON games.id = scores.game_id \
      WHERE games.lobby_id = ?"
    query += " AND games.created_at >= now()::date" if params["daily"]?
    scores = Score.all(query, [params["id"]]).group_by { |score| score.user_id }
      .map { |id, scores| {"score" => scores.sum { |s| s.points || 0 }, "nickname" => users[id]} }

    respond_with do
      json scores.to_json
    end
  end
end

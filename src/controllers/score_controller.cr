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
    scores[current_user_id] = [Score.new(points: 0)] unless scores[current_user_id]?

    response = scores.map do |id, scores|
      {"score" => scores.sum { |s| s.points || 0 }, "nickname" => users[id], "id" => id}
    end.sort { |a, b| b["score"].as(Int32) <=> a["score"].as(Int32) }

    respond_with do
      json response.to_json
    end
  end

  private def current_user_id
    session["current_user_id"].not_nil!.to_i
  end
end

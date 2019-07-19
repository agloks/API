require "http/web_socket"

class GameService
  @game : Game

  def initialize(@lobby : Lobby)
    @ws = HTTP::WebSocket.new(URI.parse("ws://#{ENV["DOMAIN"]}/game"))
    @topic = "game_room:lobby_#{@lobby.id}"
    @game = Game.new
  end

  def run
    if Game.find_by(lobby_id: @lobby.id, running: true)
      return Monads::Left.new([{"game" => "A game is already running"}])
    end

    medias = Media.all("JOIN questions ON medias.id = questions.media_id \
      WHERE medias.theme_id = ? AND questions.answers <> ''", [@lobby.theme.id])
    if medias.size < @lobby.questions.not_nil!
      return Monads::Left.new([{"medias" => "Not enough questions for this lobby"}])
    end

    @game = game = Game.create(running: true, lobby_id: @lobby.id)
    add_players(all_players)
    send_new_game_message

    spawn do
      medias.shuffle[0...@lobby.questions].each_with_index do |media, index|
        question = media.questions.shuffle[0]
        add_players(missing_players)
        send_new_round_message(media, question, index)
        15.times do |time|
          sleep 1
          send_timer_message(time)
        end
        send_finish_round_message(question)
        sleep 5
      end

      game.update(running: false)
      send_finish_game_message
    end

    Monads::Right.new(@game)
  end

  private def send_new_round_message(media, question, index)
    payload = {
      "game_id"     => @game.id,
      "turn"        => index + 1,
      "media_id"    => media.id,
      "kind"        => media.kind,
      "question_id" => question.id,
      "file_url"    => media.file_url,
      "question"    => question.content,
    }
    GameSocket.broadcast("message", @topic, "round:new", payload)
  end

  private def send_timer_message(time)
    GameSocket.broadcast("message", @topic, "timer:increment", {"time" => time})
  end

  private def send_finish_round_message(question)
    payload = {
      "game_id"     => @game.id,
      "question_id" => question.id,
      "question"    => question.content,
      "answers"     => question.answers,
      "score"       => round_score(question),
      "total"       => game_score,
    }
    GameSocket.broadcast("message", @topic, "round:finish", payload)
  end

  private def send_new_game_message
    GameSocket.broadcast("message", @topic, "game:new", {"game_id" => @game.id})
  end

  private def send_finish_game_message
    payload = {"game_id" => @game.id, "score" => game_score}
    GameSocket.broadcast("message", @topic, "game:finish", payload)
  end

  private def round_score(question)
    Score.where(question_id: question.id, game_id: @game.id).select.each_with_object({} of Int64 => Int32) do |score, hash|
      hash[score.user.id.not_nil!] = score.points.not_nil!
    end
  end

  private def game_score
    scores = Score.where(game_id: @game.id).select.group_by { |score| score.user_id }
      .map { |id, scores| {id => scores.sum { |s| s.points || 0 }} }
    scores.empty? ? Hash(String, String).new : scores[0]
  end

  private def add_players(users)
    users.each do |user|
      GameUser.create(user_id: user.id, game_id: @game.id)
    end
  end

  private def missing_players
    query = "LEFT JOIN games_users gu ON gu.user_id = users.id \
      WHERE users.lobby_id = ? AND gu.id IS NULL"
    User.all(query, [@lobby.id])
  end

  private def all_players
    User.where(lobby_id: @lobby.id).select
  end
end

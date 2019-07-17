require "levenshtein"

class ChatRoomChannel < Amber::WebSockets::Channel
  def handle_joined(client_socket, message)
    payload = message["payload"]
    user_id = ::Auth::JWTService.new.decode(payload["JWT"].to_s)[0]["user_id"].to_s
    lobby_id = message["topic"].to_s.split(":lobby_")[1]
    store_channel_key(user_id, lobby_id, client_socket.id)

    running_game = Game.find_by(lobby_id: lobby_id, running: true)
    if running_game != nil
      game_user = GameUser.find_by(user_id: user_id, game_id: running_game.not_nil!.id)
      GameUser.create(user_id: user_id, game_id: running_game.not_nil!.id) if game_user == nil
    end
  end

  def handle_message(client_socket, message)
    payload = message["payload"]
    user = User.find(::Auth::JWTService.new.decode(payload["JWT"].to_s)[0]["user_id"].to_s)
    return if user.nil?
    lobby_id = message["topic"].to_s.split(":lobby_")[1]
    answer = payload["content"].to_s
    running_game = Game.find_by(lobby_id: lobby_id, running: true)
    scores = [0]

    Message.create(content: answer, lobby_id: lobby_id, user_id: user.id)

    if running_game && payload["question_id"]?
      question = Question.find payload["question_id"].to_s

      if question
        score = JSON.parse(question.answers.not_nil!).as_a.map do |a|
          points = 200 - 200 / a.as_s.size * Levenshtein.distance(a.as_s, answer)
          points.positive? ? points : 0
        end.max
        store_score(user.id, question.id, running_game.id, score)
      end
    end

    string = JSON.build do |json|
      json.object do
        json.field "event", "message"
        json.field "topic", message["topic"].to_s
        json.field "subject", "msg:new"
        json.field "payload" do
          json.object do
            json.field "user" do
              json.object do
                json.field "id", user.id
                json.field "nickname", user.nickname
              end
            end
            json.field "score", score.to_s
            json.field "content", answer
          end
        end
      end
    end
    rebroadcast!(JSON.parse(string))
  end

  def handle_leave(client_socket)
    user = User.find_by(chat_socket: client_socket.id)
    user.update(chat_socket: nil, lobby_id: nil) if user
  end

  private def store_score(user_id, question_id, game_id, points)
    return if points == nil
    score = Score.find_by(user_id: user_id, game_id: game_id, question_id: question_id)
    if score && points > score.points.not_nil!
      score.update(points: points)
    else
      Score.create(user_id: user_id, game_id: game_id, question_id: question_id, points: points)
    end
  end

  private def store_channel_key(user_id, lobby_id, socket_id)
    user = User.find!(user_id)
    user.update(lobby_id: lobby_id, chat_socket: socket_id)
  end
end

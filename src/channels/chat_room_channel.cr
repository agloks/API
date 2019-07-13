require "levenshtein"

class ChatRoomChannel < Amber::WebSockets::Channel
  def handle_joined(client_socket, message)
  end

  def handle_message(client_socket, message)
    payload = message["payload"]
    lobby_id = message["topic"].to_s.split(":lobby_")[1]
    user_id = ::Auth::JWTService.new.decode(payload["JWT"].to_s)[0]["user_id"].to_s
    question = Question.find payload["question_id"].to_s
    answer = payload["content"].to_s
    results = [0]

    Message.create(content: answer, lobby_id: lobby_id, user_id: user_id)
    if question
      results = JSON.parse(question.answers.not_nil!).as_a.map do |a|
        score = 200 - 200 / a.as_s.size * Levenshtein.distance(a.as_s, answer)
        score.positive? ? score : 0
      end
    end

    # TODO: store score
    # TODO: calculate score
    string = JSON.build do |json|
      json.object do
        json.field "event", "message"
        json.field "topic", message["topic"].to_s
        json.field "subject", "msg:new"
        json.field "payload" do
          json.object do
            json.field "user_id", user_id
            json.field "score", results.max.to_s
            json.field "content", answer
          end
        end
      end
    end
    rebroadcast!(JSON.parse(string))
  end

  def handle_leave(client_socket)
  end
end

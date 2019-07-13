require "levenshtein"

class ChatRoomChannel < Amber::WebSockets::Channel
  def handle_joined(client_socket, message)
  end

  def handle_message(client_socket, message)
    pp "coucou"
    lobby_id = message["topic"].to_s.split(":lobby_")[1]
    user_id = ::Auth::JWTService.new.decode(message["JWT"].to_s)[0]["user_id"].to_s
    question = Question.find message["question_id"].to_s
    answer = message["content"].to_s
    results = [0]

    Message.create(content: answer, lobby_id: lobby_id, user_id: user_id)
    if question
      results = JSON.parse(question.answers.not_nil!).as_a.map do |a|
        Levenshtein.distance(a.as_s, answer) / a.as_s.size.to_f
      end
      pp results
    end

    pp message["content"]


    string = JSON.build do |json|
      json.object do
        json.field "event", "message"
        json.field "topic", message["topic"].to_s
        json.field "content", answer
        json.field "user_id", user_id
        json.field "score", results.min
      end
    end
    rebroadcast!(JSON.parse(string))
  end

  def handle_leave(client_socket)
  end
end

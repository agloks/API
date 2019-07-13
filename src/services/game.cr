require "http/web_socket"

class GameService
  def initialize(@lobby : Lobby)
    @ws = HTTP::WebSocket.new(URI.parse("ws://localhost:3000/game"))
    @topic = "game_room:lobby_#{@lobby.id}"
  end

  def run
    medias = Media.where(theme_id: @lobby.theme.id).select.shuffle[0...@lobby.questions]
    @ws.send(join_message)
    @ws.send(message("", "game:new"))

    medias.each do |media|
      question = media.questions.shuffle[0]
      @ws.send(message(question_payload(media, question), "round:new"))
      15.times do |time|
        sleep 1
        @ws.send(message(timer_payload(time + 1), "timer:increment"))
      end
      @ws.send(message(results_payload(question), "round:finish"))
      sleep 5
    end

    @ws.send(message(game_payload, "game:finish"))
    @ws.send(leave_message)
    @ws.close
  end

  private def join_message
    JSON.build do |json|
      json.object do
        json.field "event", "join"
        json.field "topic", @topic
      end
    end
  end

  private def message(payload, subject)
    JSON.build do |json|
      json.object do
        json.field "event", "message"
        json.field "topic", @topic
        json.field "subject", subject
        json.field "payload", payload
      end
    end
  end

  private def leave_message
    JSON.build do |json|
      json.object do
        json.field "event", "leave"
        json.field "topic", @topic
      end
    end
  end

  private def question_payload(media, question)
    JSON.build do |json|
      json.object do
        json.field "media_id", media.id
        json.field "question_id", question.id
        json.field "file_url", media.file_url
        json.field "question", question.content
      end
    end
  end

  private def timer_payload(time)
    JSON.build do |json|
      json.object do
        json.field "time", time
      end
    end
  end

  # TODO: score
  private def results_payload(question)
    JSON.build do |json|
      json.object do
        json.field "question_id", question.id
        json.field "question", question.content
        json.field "answers", question.answers
        json.field "score", "[]"
      end
    end
  end

  # TODO: ranking
  private def game_payload
    JSON.build do |json|
      json.object do
        json.field "score", "[]"
      end
    end
  end
end

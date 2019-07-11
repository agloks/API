class MessageController < ApplicationController
  def index
    messages = Message.where(lobby_id: params["id"]).order(:created_at).limit(200).select
    respond_with do
      json messages.to_json
    end
  end
end

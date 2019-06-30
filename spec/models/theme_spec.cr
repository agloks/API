require "./spec_helper"
require "../../src/models/theme.cr"

describe Theme do
  Spec.before_each do
    Theme.clear
  end

  describe "relations" do
    it "has many medias" do
      theme = Theme.create(title: "theme title", description: "description")
      media_1 = Media.create(title: "media title 1", kind: "picture", theme_id: theme.id)
      media_2 = Media.create(title: "media title 2", kind: "picture", theme_id: theme.id)

      theme.medias.map(&.id).should eq([media_1.id, media_2.id])
    end

    it "has many lobbies" do
      theme = Theme.create(title: "theme title", description: "description")
      lobby_1 = Lobby.create(restricted: true, theme_id: theme.id)
      lobby_2 = Lobby.create(restricted: false, theme_id: theme.id)

      theme.lobbies.map(&.id).should eq([lobby_1.id, lobby_2.id])
    end

    it "belongs to a user" do
      user = User.create(email: "test@test.fr")
      theme = Theme.create(title: "theme title", description: "description", user_id: user.id)

      theme.user.class.should eq(User)
      theme.user.email.should eq("test@test.fr")
    end
  end
end

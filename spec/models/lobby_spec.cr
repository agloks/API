require "./spec_helper"
require "../../src/models/lobby.cr"

describe Lobby do
  Spec.before_each do
    Lobby.clear
  end

  describe "relations" do
    it "belongs to a theme" do
      theme = Theme.create(title: "Theme title")
      lobby = Lobby.create(restricted: false, theme_id: theme.id)

      lobby.theme.class.should eq(Theme)
      lobby.theme.title.should eq("Theme title")
    end
  end
end

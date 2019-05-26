require "./spec_helper"
require "../../src/models/media.cr"

describe Media do
  Spec.before_each do
    Media.clear
  end

  describe "relations" do
    it "belongs to a theme" do
      theme = Theme.create(title: "theme title", description: "description")
      media = Media.create(title: "media title", kind: "picture", theme_id: theme.id)

      media.theme.class.should eq(Theme)
      media.theme.title.should eq("theme title")
    end
  end

  describe "scopes" do
    describe "pictures" do
      it "returns all pictures" do
        picture = Media.create(title: "picture title", kind: "picture")

        Media.pictures.select.map(&.id).should eq([picture.id])
      end
    end
  end

  describe "specific" do
    describe "when media is a picture" do
      it "returns a Picture" do
        media = Media.new(title: "title", kind: "picture")
        picture = media.specific

        picture.class.should eq(Picture)
        picture.title.should eq(media.title)
      end
    end
  end
end

require "granite/adapter/pg"

database_url = ENV["DATABASE_URL"]? ? ENV["DATABASE_URL"] : Amber.settings.database_url
Granite::Adapters << Granite::Adapter::Pg.new({name: "pg", url: database_url})
Granite.settings.logger = Amber.settings.logger.dup
Granite.settings.logger.not_nil!.progname = "Granite"

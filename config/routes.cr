Amber::Server.configure do
  pipeline :api do
    plug Amber::Pipe::PoweredByAmber.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Pipes::Auth.new
    # plug Amber::Pipe::CORS.new
  end

  pipeline :public_api do
    plug Amber::Pipe::PoweredByAmber.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    # plug Amber::Pipe::CORS.new
  end

  # All static content will run these transformations
  pipeline :static do
    plug Amber::Pipe::PoweredByAmber.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Static.new("./public")
  end

  routes :api do
    resources "/users", UserController, except: [:create, :new, :edit]
    delete "/auth/sign_out", SessionController, :delete

    resources "/themes", ThemeController, except: [:new, :edit]
  end

  routes :public_api do
    post "/auth/sign_up", UserController, :create
    post "/auth/sign_in", SessionController, :create
  end

  routes :static do
    # Each route is defined as follow
    # verb resource : String, controller : Symbol, action : Symbol
    get "/*", Amber::Controller::Static, :index
  end
end

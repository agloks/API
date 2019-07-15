Amber::Server.configure do
  pipeline :api do
    plug Amber::Pipe::PoweredByAmber.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Pipes::CORS.new(methods: %w(POST PUT PATCH DELETE GET))
    plug Pipes::Auth.new
  end

  pipeline :public_api do
    plug Amber::Pipe::PoweredByAmber.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Pipes::CORS.new(methods: %w(POST PUT PATCH DELETE GET))
  end

  # All static content will run these transformations
  pipeline :static do
    plug Amber::Pipe::PoweredByAmber.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Static.new("./public")
  end

  routes :api do
    # User
    resources "/users", UserController, except: [:create, :new, :edit]
    delete "/auth/sign_out", SessionController, :delete
    resources "/friendships", FriendshipController, only: [:index, :create, :update]

    # Set up
    resources "/themes", ThemeController, except: [:new, :edit]
    resources "/themes/:theme_id/medias", MediaController, except: [:new, :edit]
    resources "/medias/:media_id/questions", QuestionController, except: [:new, :edit]

    # Game
    resources "/lobbies", LobbyController, except: [:new, :edit, :update]
    resources "/lobbies/:id/users", LobbySessionController, only: [:index]
    resources "/lobbies/:id/join", LobbySessionController, only: [:create]
    resources "/lobbies/:id/messages", MessageController, only: [:index]
    resources "/game", GameController, only: [:create]
    websocket "/chat", ChatSocket
    websocket "/game", GameSocket
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

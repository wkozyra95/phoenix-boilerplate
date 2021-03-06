defmodule StarterProject.Router do
  use StarterProject.Web, :router

  pipeline :api do
      plug :accepts, ["json"]
  end

  pipeline :api_auth do  
      plug Guardian.Plug.VerifyHeader, realm: "Bearer"
      plug Guardian.Plug.LoadResource
      plug Guardian.Plug.EnsureAuthenticated, handler: StarterProject.GuardianHandler
  end  

  scope "/", StarterProject do
    pipe_through :api

    post "/auth/register", AuthController, :register
    post "/auth/login", AuthController, :login
    post "/auth/google", AuthController, :google_auth
  end

  scope "/", StarterProject do
    pipe_through :api_auth

    get "/user", UserController, :show
    post "/user", UserController, :update
    post "/auth/change_password", AuthController, :change_password
  end
end

defmodule StarterProject.Router do
  use StarterProject.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", StarterProject do
    pipe_through :api
  end
end

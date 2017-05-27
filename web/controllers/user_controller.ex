defmodule StarterProject.UserController do
  use StarterProject.Web, :controller

  alias StarterProject.User
  plug :put_view, StarterProject.AuthView

  def show(conn, _ ) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "user.json", user: user)
  end

  def update(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    changeset = User.changeset user, params
    case Repo.update changeset do
      {:ok, user} ->
        conn
        |> put_status(200)
        |> render("user.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render("error.json", changeset_error: changeset)
    end
  end
end

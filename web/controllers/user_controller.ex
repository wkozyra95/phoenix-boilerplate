defmodule StarterProject.UserController do
  @moduledoc """
  REST controller responsible for handling account data not required for authenticaton.
  """
  use StarterProject.Web, :controller

  alias StarterProject.User
  plug :put_view, StarterProject.AuthView

  @doc """
  Endpoint for fetching user account data
  """
  @spec show(Plug.Conn.t, map) :: Plug.Conn.t
  def show(conn, _ ) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "user.json", user: user)
  end


  @doc """
  Endpoint for updateing user
  """
  @spec update(Plug.Conn.t, map) :: Plug.Conn.t
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
        |> render("error.json", changeset: changeset)
    end
  end
end

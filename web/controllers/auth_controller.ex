defmodule StarterProject.AuthController do
  use StarterProject.Web, :controller

  alias StarterProject.User


  def login(conn, %{} = params) do
    case User.find_and_confirm_password(params) do
      {:ok, user} ->
        IO.inspect params
        conn = Guardian.Plug.api_sign_in(conn, user)
        jwt = Guardian.Plug.current_token(conn)

        conn
        |> put_status(200)
        |> put_resp_header("authorization", jwt)
        |> render("login.json", user: user, jwt: jwt)
      {:error, message} ->
        conn
        |> put_status(400)
        |> render("error.json", form_error: message)
    end
  end

  def register(conn, %{} = user) do
    changeset = User.register_changeset %User{}, user
    case Repo.insert changeset do
      {:ok, user} -> 
        conn
        |> put_status(201)
        |> render("user.json", user: user)
      {:error, changeset} ->
        conn 
        |> put_status(400)
        |> render("error.json", changeset: changeset)
    end
  end

end

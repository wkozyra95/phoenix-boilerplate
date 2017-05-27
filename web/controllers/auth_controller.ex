defmodule StarterProject.AuthController do
  use StarterProject.Web, :controller

  alias StarterProject.User

  plug :scrub_params, "username" when action in [:login, :register]
  plug :scrub_params, "password" when action in [:login, :register]
  plug :scrub_params, "email" when action in [:register]

  def login(conn, %{ "username" => username, "password" => password } = params) do
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

  def register(conn, %{ "username" => username, "password" => password, "email" => email } = user) do
    changeset = User.register_changeset %User{}, user
    case Repo.insert changeset do
      {:ok, user} -> 
        conn
        |> put_status(201)
        |> render("user.json", user: user)
      {:error, changeset} ->
        conn 
        |> put_status(400)
        |> render("error.json", changeset_error: changeset)
    end
  end

end

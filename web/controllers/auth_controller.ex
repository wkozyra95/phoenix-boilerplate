defmodule StarterProject.AuthController do
  use StarterProject.Web, :controller

  alias StarterProject.User
  alias StarterProject.GoogleVerify


  def login(conn, %{} = params) do
    case User.find_and_confirm_password(params) do
      {:ok, user} ->
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
    def change_password(conn, %{} = params) do
    user = Guardian.Plug.current_resource(conn)
    changeset = User.change_password_changeset user, params
    case Repo.update changeset do
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

  def google_auth(conn, %{ "tokenId" => token } = params) do
    case GoogleVerify.get_token_clamps(token) do  
      {:ok, %{"email" => email} = clamps} ->
        case Repo.get_by(User, email: email) do
          user when not is_nil(user) ->
            conn = Guardian.Plug.api_sign_in(conn, user)
            jwt = Guardian.Plug.current_token(conn)
            conn
            |> put_status(201)
            |> render "login.json", user: user, jwt: jwt
          _ ->
            case Repo.insert(%User{ username: email, email: email }) do
              {:ok, user} ->
                conn = Guardian.Plug.api_sign_in(conn, user)
                jwt = Guardian.Plug.current_token(conn)
                conn
                |> put_status(200)
                |> render("login.json", user: user, jwt: jwt)
            end
        end
      _ ->
        conn
        |> put_status(400)
        |> json(%{ reason: "invalid token"})
    end
  end
end


defmodule StarterProject.AuthControllerTest do
  use StarterProject.ConnCase

  alias StarterProject.User
  @password "password"
  @username "username"
  @email "email@email"
  @email_invalid "email"
  @register_data %{ "password" => @password, "username" => @username, "email" => @email }
  @login_data %{ "password" => @password, "username" => @username }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "login user when data is valid", %{conn: conn} do
    %User{}
    |> User.register_changeset(@register_data) 
    |> Repo.insert

    conn = post conn, auth_path(conn, :login), @login_data
    assert json_response(conn, 200)["user"]
    assert json_response(conn, 200)["token"]
    assert Repo.get_by(User, username: @username)
  end

  test "login user when nonexistent", %{conn: conn} do
    conn = post conn, auth_path(conn, :login), @login_data
    assert json_response(conn, 400)["all"]
    assert nil == Repo.get_by(User, username: @username)
  end
  
  test "login user when wrong password", %{conn: conn} do
    %User{}
    |> User.register_changeset(@register_data) 
    |> Repo.insert

    conn = post conn, auth_path(conn, :login), %{ @login_data | "password" => "abc" }
    assert json_response(conn, 400)["all"]
    assert Repo.get_by(User, username: @username)
  end

end

defmodule StarterProject.AuthView do
  use StarterProject.Web, :view

  def render("user.json", %{ user: user }) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
    }
  end

  def render("login.json", %{ user: user, jwt: jwt }) do
    %{
      token: jwt,
      user: render("user.json", %{ user: user })
    }
  end

  def render("error.json", %{ form_error: error }) do
    %{ all: error }
  end

  def render("error.json", %{ changeset: error }) do
    error
    |> Ecto.Changeset.traverse_errors(fn
      {msg, opts} -> String.replace(msg, "%{count}", to_string(opts[:count]))
      msg -> msg
    end)
    |> Map.new(fn
      {key, [head | _ ]} -> {key, head}
    end)
  end
end

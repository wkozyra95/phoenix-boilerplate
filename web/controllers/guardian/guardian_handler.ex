defmodule StarterProject.GuardianHandler do
  use StarterProject.Web, :controller


  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> text("Authentication required")
  end
end


defmodule StarterProject.GoogleVerify do

  def is_token_valid(token) do
    case validate_token(token) do
      :error -> :error
      _ -> :ok
    end
  end

  def get_token_clamps(token) do
    case validate_token(token) do
      :error -> :invalid_token
      other -> {:ok, other}
    end
  end

  defp validate_token(token) do
    case HTTPotion.get("https://www.googleapis.com/oauth2/v3/tokeninfo", query: %{ id_token: token }) do
      %HTTPotion.Response{body: body} -> 
        case Poison.decode(body) do
          {:ok, %{ "email" => email, "email_verified" => "true" } = parsed_body } -> parsed_body
        _ ->
          :error
          end
      _ ->
        :error
    end
  end
end

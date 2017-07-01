defmodule StarterProject.GoogleVerify do
  @moduledoc """
  GoogleVerify is responsible for handling communication with google services and validating user authentication
  """


  @doc """
  checks if google token is valid.

  If token is valid returns :ok
  On error return :error
  """
  @spec is_token_valid(String.t)  :: :ok | :error
  def is_token_valid(token) do
    case validate_token(token) do
      :error -> :error
      _ -> :ok
    end
  end

  @doc """
  resolve valid user token to user account data. 

  If token is valid return map containg user auth data
  On error return :invalid_token
  """
  @spec get_token_clamps(String.t) :: :invalid_token | {:ok, map}
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
          {:ok, %{ "email" => _, "email_verified" => "true" } = parsed_body } -> parsed_body
        _ ->
          :error
          end
      _ ->
        :error
    end
  end
end

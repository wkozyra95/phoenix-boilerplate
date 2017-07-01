defmodule StarterProject.User do
  @moduledoc """
  This module defines struct and db schema for user account.
  """
  use StarterProject.Web, :model

  schema "user" do
    field :username, :string
    field :password, :string, virtual: true, default: ""
    field :password_hash, :string
    field :email, :string

    timestamps()
  end

  @type t :: %StarterProject.User{
    username:         String.t,
    password:         String.t,
    password_hash:    String.t,
    email:            String.t,
  }

  @doc """
  Builds a changeset based on the `struct` and `params`.
  Required for validating data.
  """
  @spec changeset(%StarterProject.User{}, map) :: Ecto.Changeset.t
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  Required for validating data durring registration.
  """
  def register_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 20)
    |> hash_password
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  Required for validating dat durring password change.
  """
  def change_password_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> update_password(params)
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 20)
  end
  
  def update_password(
      changeset, 
      %{ "newPassword" => new_password, "oldPassword" => old_password}
    ) do
    if String.length(new_password) == 0 do
      changeset = changeset |> add_error(:password, "can't be empty")
    end
    if String.length(old_password) == 0 do
      changeset = changeset |> add_error(:oldPassword, "can't be empty")
    end

    compare = Comeonin.Bcrypt.checkpw(
      old_password,
      get_field(changeset, :password_hash)
    )

    case compare do
      true -> 
        changeset
        |> put_change(:password_hash, Comeonin.Bcrypt.hashpwsalt(new_password))
        |> put_change(:password, new_password)
      false ->
        changeset
        |> add_error(:oldPassword, "Password is incorrect")
        |> put_change(:password, new_password)
    end
  end

  def hash_password(changeset) do
    hash = changeset
    |> get_field(:password)
    |> Comeonin.Bcrypt.hashpwsalt
    
    changeset
    |> put_change(:password_hash, hash)
  end

  def find_and_confirm_password(%{ "username" => username, "password" => password }) do 
    with user when not is_nil(user) <- Repo.get_by(StarterProject.User, username: username),
      true <- Comeonin.Bcrypt.checkpw(password, user.password_hash)
    do
      {:ok, user} 
    else 
      nil -> {:error, "Invalid email or password"}
      false -> {:error, "Invalid email or password"}
    end
  end
end

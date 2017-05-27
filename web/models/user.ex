defmodule StarterProject.User do
  use StarterProject.Web, :model

  schema "user" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :email, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  def register_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 20)
    |> hash_password
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
    end
  end
end

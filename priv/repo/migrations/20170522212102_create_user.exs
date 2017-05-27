defmodule StarterProject.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :username,      :string
      add :password_hash, :string
      add :email,         :string

      timestamps()
    end
    create unique_index(:user, [:email])
    create unique_index(:user, [:username])
  end
end

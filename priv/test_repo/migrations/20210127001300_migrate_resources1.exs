defmodule AshPostgres.TestRepo.Migrations.MigrateResources1 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION \"citext\";")
    execute("CREATE EXTENSION \"uuid-ossp\";")
    execute("CREATE EXTENSION \"pg_trgm\";")

    create table(:posts, primary_key: false) do
      add :id, :binary_id, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
      add :title, :text
      add :score, :integer
      add :public, :boolean
      add :category, :citext
    end

    create table(:multitenant_orgs, primary_key: false) do
      add :id, :binary_id, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
      add :name, :text
    end

    create unique_index(:multitenant_orgs, [:id, :name],
             name: "multitenant_orgs_unique_by_name_unique_index"
           )

    create table(:comments, primary_key: false) do
      add :id, :binary_id, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
      add :title, :text
      add :post_id, references("posts", type: :binary_id, column: :id)
    end
  end

  def down do
    drop table("comments")

    drop_if_exists unique_index(:multitenant_orgs, [:id, :name],
                     name: "multitenant_orgs_unique_by_name_unique_index"
                   )

    drop table("multitenant_orgs")

    drop table("posts")

    execute("DROP EXTENSION \"citext\"")
    execute("DROP EXTENSION \"uuid-ossp\"")
    execute("DROP EXTENSION \"pg_trgm\"")
  end
end

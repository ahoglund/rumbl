defmodule Rumbl.Repo.Migrations.AddCategoryIdToVideo do
  use Ecto.Migration

  def change do
    alter table(:videos) do
B      add :category_id, references(:categories)
    end
  end
end

# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rumbl.Repo.insert!(%Rumbl.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias Rumbl.Repo
alias Rumbl.Category
alias Rumbl.User

for category <- ~w(Jazz Funk Soul Gospel R&B) do
  Repo.get_by(Category, name: category) || Repo.insert!(%Category{name: category})
end

users =
[%{id: 1, name: "Andrew", username: "andrew", password: "local"},
 %{id: 2, name: "Colin",  username: "colin", password: "local"},
 %{id: 3, name: "Paul",   username: "paul", password: "local"},
 %{id: 4, name: "Tim",    username: "tim", password: "local"},
 %{id: 5, name: "Kathy",  username: "kathy", password: "local"},
 %{id: 6, name: "Gisel",  username: "gisel", password: "local"},
 %{id: 7, name: "Ethan",  username: "ethan", password: "local"},
 %{id: 8, name: "Liam",   username: "liam", password: "local"},
 %{id: 9, name: "Julian", username: "julian", password: "local"},]

for user <- users do
  changeset = User.registration_changeset(%User{}, user)
  Repo.get_by(User, username: user.username) || Repo.insert!(changeset)
end

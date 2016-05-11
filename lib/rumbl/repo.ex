defmodule Rumbl.Repo do
  # use Ecto.Repo, otp_app: :rumbl

  @moduledoc """
  In memory Repository
  """

  def get(module, id) do
    Enum.find all(module), fn map -> map.id == id end
  end

  def get_by(module, params) do
    Enum.find all(module), fn map ->
      Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
    end
  end

  def all(Rumbl.User) do
    [%Rumbl.User{id:  "1", name: "Andrew Hoglund", username: "ahoglund", password: "local"},
      %Rumbl.User{id: "2", name: "Colin Hoglund",  username: "choglund", password: "local"},
      %Rumbl.User{id: "3", name: "Paul Hoglund",   username: "phoglund", password: "local"},
      %Rumbl.User{id: "4", name: "Tim Hoglund",    username: "thoglund", password: "local"},
      %Rumbl.User{id: "5", name: "Kathy Hoglund",  username: "khoglund", password: "local"},
      %Rumbl.User{id: "6", name: "Gisel Hoglund",  username: "ghoglund", password: "local"},
      %Rumbl.User{id: "7", name: "Ethan Hoglund",  username: "ehoglund", password: "local"},
      %Rumbl.User{id: "8", name: "Liam Hoglund",   username: "lhoglund", password: "local"},
      %Rumbl.User{id: "9", name: "Julian Hoglund", username: "jhoglund", password: "local"},]
  end

  def all(_module), do: []
end

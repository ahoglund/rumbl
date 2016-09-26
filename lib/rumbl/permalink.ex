defmodule Rumbl.Permalink do
  @behaviour Ecto.Type

  def type, do: :id

  def cast(string) when is_binary(string) do
    case Integer.parse(string) do
      {int, _} -> {:ok, int}
      :error   -> :error
    end
  end

  def cast(int) when is_integer(int), do: {:ok, int}
  def cast(_), do: :error
  def load(int) when is_integer(int), do: {:ok, int}
  def dump(int) when is_integer(int), do: {:ok, int}
  def dump(_), do: :error
end

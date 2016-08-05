defmodule Red.Query do
  alias Red.Query.Meta
  alias Red.{Relation, Entity, Query, Edge}

  defstruct queryable: nil, meta: %Meta{}

  @type queryable_t :: %Relation{} |
                       %Entity{} |
                       %Query{} |
                       %Edge{} |
                       {Entity.class_t, Entity.id_t} |
                       Entity.id_t

  @type t :: %Red.Query{queryable: queryable_t, meta: Meta.t}

  def ops(%__MODULE__{} = query, :fetch) do
    [
      Red.key(query),
      query.meta.offset,
      limit(query)
    ]
  end

  defp limit(%{meta: %{limit: -1}}), do: -1

  defp limit(%{meta: %{limit: l}}),  do: l - 1
end

defimpl Enumerable, for: Red.Query do
  alias Red.{Query, Client}

  def count(query) do
    with {:ok, count} <-
      query
      |> Red.key
      |> Client.exec("ZCARD"), do: {:ok, count}
  end

  def member?(query, value) do
    with {:ok, score} <-
      [query, value]
      |> Enum.map(&Red.key/1)
      |> Client.exec("ZSCORE"), do: {:ok, !is_nil(score)}
  end

  def reduce(query, acc, fun) do
    query
    |> Query.ops(:fetch)
    |> Client.exec!("ZREVRANGE")
    |> Enumerable.reduce(acc, fun)
  end
end

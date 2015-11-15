defmodule Red.Query do
  defstruct queryable: nil, meta: %Red.Query.Meta{}

  def ops(%Red.Query{} = query, :fetch) do
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
  def count(query) do
    query
    |> Red.key
    |> Red.Client.exec("ZCARD")
  end

  def member?(query, value) do
    [query, value]
    |> Enum.map(&Red.key &1)
    |> Red.Client.exec("ZSCORE")
  end

  def reduce(query, acc, fun) do
    {:ok, collection} = query
    |> Red.Query.ops(:fetch)
    |> Red.Client.exec("ZREVRANGE")

    Enumerable.reduce(collection, acc, fun)
  end
end

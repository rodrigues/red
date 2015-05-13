defmodule Red.Query do

  defstruct queryable: nil, meta: %Red.Query.Meta{}

  def ops(%Red.Query{} = query, :fetch) do
    [
      "ZREVRANGE",
      Red.Rel.key(query.queryable),
      query.meta.offset,
      limit(query)
    ]
  end

  defp limit(%{meta: %{limit: -1}}), do: -1
  defp limit(%{meta: %{limit: l}}),  do: l - 1

end

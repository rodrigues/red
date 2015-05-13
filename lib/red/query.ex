defmodule Red.Query do

  defstruct queryable: nil, meta: %Red.Query.Meta{}

  def ops(%Red.Query{} = query, :fetch) do
    [
      "ZREVRANGE",
      Red.Rel.key(query.queryable),
      query.meta.offset,
      query.meta.limit
    ]
  end

end

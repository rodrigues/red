defmodule Red do

  @doc ~S"""
    Returns a node.

    ## Examples

    iex> Red.node(1)
    %Red.Node{id: 1}

    iex> Red.node({:user, 42})
    %Red.Node{class: :user, id: 42}

    iex> Red.node("user#42")
    %Red.Node{class: "user", id: "42"}

    iex> Red.node("key")
    %Red.Node{id: "key"}

    iex> %Red.Node{id: 1} |> Red.node
    %Red.Node{id: 1}
  """
  def node(n), do: Red.Node.build(n)

  @doc ~S"""
    Returns a relation.

    ## Examples

    iex> "user#42" |> Red.rel(:in, :follow)
    %Red.Rel{
      name: :follow,
      direction: :in,
      node: %Red.Node{class: "user", id: "42"}
    }
  """
  def rel(node, direction, name) when direction in [:in, :out] do
    %Red.Rel{name: name, direction: direction, node: Red.node(node)}
  end

  def query(%Red.Rel{} = rel) do
    %Red.Query{queryable: rel}
  end

  def limit(%Red.Rel{} = rel, limit) do
    %{query(rel) | meta: %Red.Query.Meta{limit: limit}}
  end

  def limit(%Red.Query{} = query, limit) do
    %{query | meta: %{query.meta | limit: limit}}
  end

  def offset(%Red.Rel{} = rel, offset) do
    %{query(rel) | meta: %Red.Query.Meta{offset: offset}}
  end

end

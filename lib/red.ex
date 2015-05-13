defmodule Red do
  use Exredis

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

  def edge(%Red.Rel{} = rel, target_node) do
    %Red.Edge{rel: rel, target: Red.node(target_node)}
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

  def offset(%Red.Query{} = query, offset) do
    %{query | meta: %{query.meta | offset: offset}}
  end

  def add!(%Red.Rel{} = rel, end_node) do
    rel
      |> Red.edge(end_node)
      |> Red.Edge.ops(:add)
      |> exec_pipe
  end

  def fetch!(%Red.Rel{} = rel) do
    query(rel)
      |> fetch!
  end

  def fetch!(%Red.Query{} = query) do
    query
      |> Red.Query.ops(:fetch)
      |> exec
  end

  def redis do
    "redis://127.0.0.1:6379/12"
      |> Exredis.start_using_connection_string
  end

  defp exec(op) do
    redis
      |> Exredis.query(op)
  end

  defp exec_pipe(ops) do
    redis
      |> Exredis.query_pipe(ops)
  end

end

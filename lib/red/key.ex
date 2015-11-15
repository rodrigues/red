defmodule Red.Key do
  def build(%Red.Rel{} = rel) do
    "#{build(rel.node)}:#{rel.name}:#{rel.direction}"
  end

  def build(%Red.Node{class: nil} = node), do: node.id

  def build(%Red.Node{} = node), do: "#{node.class}##{node.id}"

  def build(%Red.Query{} = query), do: build(query.queryable)

  def build(%Red.Edge{} = edge), do: build(edge.rel)

  def build(_), do: nil
end

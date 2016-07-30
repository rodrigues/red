defmodule Red.Key do
  alias Red.{Entity, Relation, Edge, Query}

  def build(%Relation{} = relation) do
    "#{build(relation.entity)}:#{relation.name}:#{relation.direction}"
  end

  def build(%Entity{class: nil} = entity), do: entity.id

  def build(%Entity{} = entity), do: "#{entity.class}##{entity.id}"

  def build(%Query{} = query), do: build(query.queryable)

  def build(%Edge{} = edge), do: build(edge.relation)

  def build({class, id}), do: build(%Entity{class: class, id: id})

  def build(id) when is_number(id) or is_bitstring(id), do: "#{id}"
end

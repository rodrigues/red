defmodule Red.Key do
  alias Red.{Entity, Rel, Edge, Query}

  def build(%Rel{} = rel) do
    "#{build(rel.entity)}:#{rel.name}:#{rel.direction}"
  end

  def build(%Entity{class: nil} = red_entity), do: red_entity.id

  def build(%Entity{} = red_entity), do: "#{red_entity.class}##{red_entity.id}"

  def build(%Query{} = query), do: build(query.queryable)

  def build(%Edge{} = edge), do: build(edge.rel)

  def build({class, id}), do: build(%Entity{class: class, id: id})

  def build(id) when is_number(id) or is_bitstring(id), do: "#{id}"
end

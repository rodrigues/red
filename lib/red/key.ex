defmodule Red.Key do
  alias Red.{Entity, Relation, Edge, Query}

  @spec build(Query.queryable_t) :: String.t
  def build(%Relation{} = relation) do
    "#{build(relation.entity)}:#{relation.name}:#{relation.direction}"
  end

  def build(%Entity{class: nil} = entity), do: entity.id

  def build(%Entity{} = entity), do: "#{entity.class}##{entity.id}"

  def build(%Query{} = query), do: query.queryable |> build

  def build(%Edge{} = edge), do: edge.relation |> build

  def build({class, id}), do: %Entity{class: class, id: id} |> build

  def build(id) when is_number(id), do: id |> to_string |> build

  def build(id) when is_bitstring(id), do: id
end

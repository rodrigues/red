defmodule Red.Relation do
  alias Red.{Entity}

  defstruct name: nil, direction: :out, entity: nil

  @type name_t :: String.t | atom
  @type t :: %Red.Relation{name: name_t, direction: atom, entity: Entity.t}
end

defimpl Enumerable, for: Red.Relation do
  def count(relation) do
    relation
    |> Red.query
    |> Enumerable.count
  end

  def member?(relation, value) do
    relation
    |> Red.query
    |> Enumerable.member?(value)
  end

  def reduce(relation, acc, fun) do
    relation
    |> Red.query
    |> Enumerable.reduce(acc, fun)
  end
end

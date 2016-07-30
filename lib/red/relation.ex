defmodule Red.Relation do
  defstruct name: nil, direction: :out, entity: nil
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

defmodule Red.Rel do
  defstruct name: nil, direction: :out, node: nil
end

defimpl Red.Key, for: Red.Rel do
  def build(rel) do
    "#{Red.key(rel.node)}:#{rel.name}:#{rel.direction}"
  end
end

defimpl Enumerable, for: Red.Rel do
  def count(rel) do
    rel
      |> Red.query
      |> Enumerable.count
  end

  def member?(rel, value) do
    rel
      |> Red.query
      |> Enumerable.member?(value)
  end

  def reduce(rel, acc, fun) do
    rel
      |> Red.query
      |> Enumerable.reduce(acc, fun)
  end
end

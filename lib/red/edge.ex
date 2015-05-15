defmodule Red.Edge do
  defstruct rel: nil, target: nil

  def ops(%Red.Edge{} = edge, :add) do
    [s, e] =
      [edge.rel.node, edge.target]
      |> Enum.map(&Red.key &1)

    if edge.rel.direction == :out, do: [s, e] = [e, s]

    [
      ["ZADD", "#{s}:#{edge.rel.name}:in",  0, e],
      ["ZADD", "#{e}:#{edge.rel.name}:out", 0, s]
    ]
  end
end

defimpl Red.Key, for: Red.Edge do
  def build(edge), do: Red.key(edge.rel)
end

defmodule Red.Edge do
  defstruct rel: nil, target: nil

  def ops(%Red.Edge{} = edge, :add) do
    [origin, target] =
      [edge.rel.node, edge.target]
      |> Enum.map(&Red.key &1)
      |> conform_to_direction(edge)

    [
      ["ZADD", "#{origin}:#{edge.rel.name}:in",  0, target],
      ["ZADD", "#{target}:#{edge.rel.name}:out", 0, origin]
    ]
  end

  defp conform_to_direction([origin, target], %{rel: %{direction: :out}}) do
    [target, origin]
  end

  defp conform_to_direction([origin, target], _), do: [origin, target]
end

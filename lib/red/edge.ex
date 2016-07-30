defmodule Red.Edge do
  defstruct relation: nil, target: nil

  def ops(%__MODULE__{} = edge, :add) do
    [origin, target] =
      [edge.relation.entity, edge.target]
      |> Enum.map(&Red.key &1)
      |> conform_to_direction(edge)

    [
      ["ZADD", "#{origin}:#{edge.relation.name}:in",  0, target],
      ["ZADD", "#{target}:#{edge.relation.name}:out", 0, origin]
    ]
  end

  defp conform_to_direction([origin, target], %{relation: %{direction: :out}}) do
    [target, origin]
  end

  defp conform_to_direction([origin, target], _), do: [origin, target]
end

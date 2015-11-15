defmodule Red.Node do
  defstruct class: nil, id: nil

  def build(%Red.Node{} = n), do: n

  def build(id) when is_integer(id), do: %Red.Node{id: id}

  def build(key) when is_bitstring(key) do
    case key |> String.split("#") do
      [id] -> %Red.Node{id: id}
      [class, id] -> %Red.Node{class: class, id: id}
    end
  end

  def build({class, id}), do: %Red.Node{class: class, id: id}
end

defmodule Red.Entity do
  defstruct class: nil, id: nil

  def build(%__MODULE__{} = entity), do: entity

  def build(id) when is_integer(id), do: %__MODULE__{id: id}

  def build({class, id}), do:   %__MODULE__{class: class, id: id}
  def build([{class, id}]), do: %__MODULE__{class: class, id: id}

  def build(key) when is_bitstring(key) do
    case key |> String.split("#") do
      [id] -> %__MODULE__{id: id}
      [class, id] -> %__MODULE__{class: class, id: id}
    end
  end
end

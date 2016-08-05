defmodule Red.Entity do
  defstruct class: nil, id: nil

  @type class_t :: atom | String.t
  @type id_t :: integer | atom | String.t
  @type t :: %Red.Entity{class: class_t, id: id_t}

  @type conversible_to_entity :: t | String.t |
    id_t | {class_t, id_t} | [{class_t, id_t}, ...]

  @spec build(conversible_to_entity) :: t
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

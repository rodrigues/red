defmodule Red.Entity do
  defstruct id: nil, class: nil

  @moduledoc """
  Provides the representation of an entity.

  The focus of Red is to persist _relations_ between entities,
  but not entities' data per se.

  Therefore, the representation of an entity is focused
  on its unique identification. A `%Red.Entity{id, class}` needs to have a `id`,
  and optionally have a `class`.

  The function `build/1` provides an extensive way to build entity structs.
  """

  @type class_t :: atom | String.t
  @type id_t :: integer | atom | String.t
  @type t :: %Red.Entity{class: class_t, id: id_t}

  @type conversible_to_entity :: t | String.t |
    id_t | {class_t, id_t} | [{class_t, id_t}, ...]

  @spec build(conversible_to_entity) :: t
  @doc """
  Builds one entity.

  Examples:

      > Red.Entity.build("45b8e48")
      %Red.Entity{id: "45b8e48", class: nil}

      > Red.Entity.build({:user, 42})
      %Red.Entity{id: 42, class: :user}
  """
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

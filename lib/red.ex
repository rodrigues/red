defmodule Red do
  alias Red.{Entity, Rel, Edge, Key, Query, Client}

  @doc ~S"""
    Returns a entity.

    ## Examples

    iex> Red.entity(1)
    %Red.Entity{id: 1}

    iex> Red.entity({:user, 42})
    %Red.Entity{class: :user, id: 42}

    iex> Red.entity("user#42")
    %Red.Entity{class: "user", id: "42"}

    iex> Red.entity("key")
    %Red.Entity{id: "key"}

    iex> Red.entity(user: 42)
    %Red.Entity{class: :user, id: 42}

    iex> %Red.Entity{id: 1} |> Red.entity
    %Red.Entity{id: 1}
  """
  defdelegate entity(n), to: Entity, as: :build

  defdelegate key(x), to: Key, as: :build

  @doc ~S"""
    Returns a relation.

    ## Examples

    iex> "user#42" |> Red.rel(:follow)
    %Red.Rel{
      name: :follow,
      direction: :out,
      entity: %Red.Entity{class: "user", id: "42"}
    }

    iex> {:user, 42} |> Red.rel(:follow, :in)
    %Red.Rel{
      name: :follow,
      direction: :in,
      entity: %Red.Entity{class: :user, id: 42}
    }
  """
  def rel(entity, name, direction \\ :out) when direction in [:in, :out] do
    %Rel{
      name: name,
      direction: direction,
      entity: Red.entity(entity)
    }
  end

  def edge(%Rel{} = rel, target_entity) do
    %Edge{
      rel: rel,
      target: Red.entity(target_entity)
    }
  end

  def query(%Rel{} = rel), do: %Query{queryable: rel}

  def limit(%Rel{} = rel, l), do: rel |> query |> limit(l)

  def limit(%Query{} = query, l) do
    %{query | meta: %{query.meta | limit: l}}
  end

  def offset(%Rel{} = rel, o), do: rel |> query |> offset(o)

  def offset(%Query{} = query, o) do
    %{query | meta: %{query.meta | offset: o}}
  end

  def add!(%Rel{} = rel, end_entities) when is_list(end_entities) do
    end_entities
    |> Stream.map(&Red.edge rel, &1)
    |> Stream.map(&Edge.ops &1, :add)
    |> Enum.reduce(&(&2 ++ &1))
    |> Client.pipeline_exec
  end

  def add!(%Red.Rel{} = rel, end_entity) do
    rel
    |> Red.edge(end_entity)
    |> Edge.ops(:add)
    |> Client.pipeline_exec
  end
end

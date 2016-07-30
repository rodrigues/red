defmodule Red do
  alias Red.{Entity, Relation, Edge, Key, Query, Client}

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

    iex> "user#42" |> Red.relation(:follow)
    %Red.Relation{
      name: :follow,
      direction: :out,
      entity: %Red.Entity{class: "user", id: "42"}
    }

    iex> {:user, 42} |> Red.relation(:follow, :in)
    %Red.Relation{
      name: :follow,
      direction: :in,
      entity: %Red.Entity{class: :user, id: 42}
    }
  """
  def relation(entity, name, direction \\ :out) when direction in [:in, :out] do
    %Relation{
      name: name,
      direction: direction,
      entity: Red.entity(entity)
    }
  end

  def edge(%Relation{} = relation, target_entity) do
    %Edge{
      relation: relation,
      target: Red.entity(target_entity)
    }
  end

  def query(%Relation{} = relation), do: %Query{queryable: relation}

  def limit(%Relation{} = relation, l), do: relation |> query |> limit(l)

  def limit(%Query{} = query, l) do
    %{query | meta: %{query.meta | limit: l}}
  end

  def offset(%Relation{} = relation, o), do: relation |> query |> offset(o)

  def offset(%Query{} = query, o) do
    %{query | meta: %{query.meta | offset: o}}
  end

  def add!(%Relation{} = relation, end_entities) when is_list(end_entities) do
    end_entities
    |> Stream.map(&Red.edge relation, &1)
    |> Stream.map(&Edge.ops &1, :add)
    |> Enum.reduce(&(&2 ++ &1))
    |> Client.pipeline_exec
  end

  def add!(%Red.Relation{} = relation, end_entity) do
    relation
    |> Red.edge(end_entity)
    |> Edge.ops(:add)
    |> Client.pipeline_exec
  end
end

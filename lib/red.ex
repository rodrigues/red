defmodule Red do
  alias Red.{Entity, Relation, Edge, Key, Query, Client}

  @moduledoc ~S"""
  Provides the main functions to work with Red.

  ## Examples

      iex> {:ok, _} = "@vcr2" |> Red.relation(:follow) |> Red.add!("@hex_pm")
      ...> "@vcr2" |> Red.relation(:follow) |> Enum.at(0)
      "@hex_pm"

      iex> "@vcr2" |> Red.relation(:follow) |> Red.add!(["@elixirlang", "@elixirphoenix"])
      ...> "@vcr2" |> Red.relation(:follow) |> Enum.count
      2

      iex> {:ok, _} = "@elixirlang" |> Red.relation(:follow) |> Red.add!("@vcr2")
      ...> "@vcr2" |> Red.relation(:follow, :in) |> Enum.count
      1

      iex> {:ok, _} = "@vcr2" |> Red.relation(:follow) |> Red.add!(~w(@a @b @c @d @e @f @g @h @i @j @k))
      ...> "@vcr2" |> Red.relation(:follow) |> Red.offset(3) |> Red.limit(5) |> Enum.to_list
      ["@h", "@g"]
  """

  @doc ~S"""
  Returns the redis key corresponding to queryable passed as argument.

  Anything that qualifies as a `t:Red.Query.queryable_t/0`
  type can be an argument.

  ## Examples

      iex> Red.key(1)
      "1"

      iex> Red.key({:user, 42})
      "user#42"

      iex> Red.key("user#42")
      "user#42"

      iex> Red.key("key")
      "key"

      iex> Red.key(user: 42)
      "user#42"

      iex> %Red.Entity{class: :user, id: 42} |> Red.key
      "user#42"

      iex> {:user, 42} |> Red.relation(:follow, :in) |> Red.key
      "user#42:follow:in"

      iex> [user: 42] |> Red.relation(:follow) |> Red.key
      "user#42:follow:out"
  """
  @spec key(Query.queryable_t) :: String.t
  defdelegate key(queryable), to: Key, as: :build

  @doc ~S"""
  Builds a `Red.Entity` representation.

  Anything that qualifies as a `t:Red.Entity.conversible_to_entity/0`
  type can be an argument.

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
  @spec entity(Entity.conversible_to_entity) :: Red.Entity.t
  defdelegate entity(args), to: Entity, as: :build

  @doc ~S"""
  Builds a `Red.Relation` representation.

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

      iex> "user#42" |> Red.relation(:follow, :out)
      %Red.Relation{
        name: :follow,
        direction: :out,
        entity: %Red.Entity{class: "user", id: "42"}
      }
  """
  @spec relation(Entity.conversible_to_entity, Relation.name_t, :in | :out) :: Relation.t
  def relation(entity, name, direction \\ :out) when direction in [:in, :out] do
    %Relation{
      name: name,
      direction: direction,
      entity: Red.entity(entity)
    }
  end

  @doc ~S"""
  Builds a `Red.Edge` representation.

  ## Examples

      iex> {:user, 42} |> Red.relation(:follow) |> Red.edge({:user, 21})
      %Red.Edge{
        relation: %Red.Relation{
          name: :follow,
          direction: :out,
          entity: %Red.Entity{class: :user, id: 42}
        },
        target: %Red.Entity{class: :user, id: 21}
      }
  """
  @spec edge(Relation.t, Entity.conversible_to_entity) :: Edge.t
  def edge(%Relation{} = relation, target_entity) do
    %Edge{
      relation: relation,
      target: Red.entity(target_entity)
    }
  end

  @doc ~S"""
  Builds a `Red.Query` representation from a `Red.Relation` representation.

  ## Examples

      iex> {:user, 42} |> Red.relation(:follow) |> Red.query
      %Red.Query{
        queryable: %Red.Relation{
          name: :follow,
          direction: :out,
          entity: %Red.Entity{class: :user, id: 42}
        },
        meta: %Red.Query.Meta{
          limit: -1,
          offset: 0
        }
      }
  """
  @spec query(Relation.t) :: Query.t
  def query(%Relation{} = relation), do: %Query{queryable: relation}

  @doc ~S"""
  Adds a page limit to the query being mounted.

  ## Examples

      iex> {:user, 42} |> Red.relation(:like) |> Red.limit(80)
      %Red.Query{
        queryable: %Red.Relation{
          name: :like,
          direction: :out,
          entity: %Red.Entity{class: :user, id: 42}
        },
        meta: %Red.Query.Meta{
          limit: 80,
          offset: 0
        }
      }
  """
  @spec limit(Relation.t | Query.t, pos_integer | -1) :: Query.t
  def limit(%Relation{} = relation, l), do: relation |> query |> limit(l)

  def limit(%Query{} = query, l) do
    %{query | meta: %{query.meta | limit: l}}
  end

  @doc ~S"""
  Adds a page offset to the query being mounted.

  ## Examples

      iex> {:user, 42} |> Red.relation(:like) |> Red.offset(21)
      %Red.Query{
        queryable: %Red.Relation{
          name: :like,
          direction: :out,
          entity: %Red.Entity{class: :user, id: 42}
        },
        meta: %Red.Query.Meta{
          limit: -1,
          offset: 21
        }
      }
  """
  @spec offset(Relation.t | Query.t, non_neg_integer) :: Query.t
  def offset(%Relation{} = relation, o), do: relation |> query |> offset(o)

  def offset(%Query{} = query, o) do
    %{query | meta: %{query.meta | offset: o}}
  end

  @doc ~S"""
  Adds relationships in redis.

  ## Examples

      iex> likes = "user#42" |> Red.relation(:like)
      ...> {:ok, _} = likes |> Red.add!("user#21")
      ...> likes |> Enum.member?("user#21")
      true

      iex> likes = "user#21" |> Red.relation(:like)
      ...> {:ok, _} = likes |> Red.add!(["user#12", "user#13"])
      ...> likes |> Enum.count
      2
  """
  @spec add!(Relationt.t, [Entity.conversible_to_entity] | Entity.conversible_to_entity) :: {:ok, [non_neg_integer]}
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

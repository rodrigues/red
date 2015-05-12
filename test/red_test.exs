defmodule RedTest do
  use ExUnit.Case
  doctest Red

  def user_followers do
    {:user, 42}
      |> Red.rel(:out, :follow)
  end

  def validate_query(query) do
    assert query.queryable.node.class == :user
    assert query.queryable.node.id == 42
    assert query.queryable.direction == :out
    assert query.queryable.name == :follow

    query
  end

  test "query(relation)" do
    user_followers
      |> Red.query
      |> validate_query
  end

  test "limit, receiving relation" do
    query = user_followers
      |> Red.limit(20)
      |> validate_query

    assert query.meta.limit == 20
  end

  test "limit, receiving a query" do
    query = user_followers
      |> Red.limit(20)
      |> Red.limit(19)
      |> validate_query

    assert query.meta.limit == 19
  end

  test "offset, receiving relation" do
    query = user_followers
      |> Red.offset(13)
      |> validate_query

    assert query.meta.offset == 13
  end

end

defmodule RedTest do
  use ExUnit.Case
  doctest Red

  setup do
    Red.Client.exec([], "FLUSHDB")
    :ok
  end

  def user_followers do
    {:user, 42}
    |> Red.rel(:follow)
  end

  def validate_query(query) do
    assert query.queryable.entity.class == :user
    assert query.queryable.entity.id == 42
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
    query =
      user_followers
      |> Red.limit(20)
      |> validate_query

    assert query.meta.limit == 20
  end

  test "limit, receiving a query" do
    query =
      user_followers
      |> Red.limit(20)
      |> Red.limit(19)
      |> validate_query

    assert query.meta.limit == 19
  end

  test "offset, receiving relation" do
    query =
      user_followers
      |> Red.offset(13)
      |> validate_query

    assert query.meta.offset == 13
  end

  test "offset, receiving a query" do
    query =
      user_followers
      |> Red.offset(13)
      |> Red.offset(31)
      |> validate_query

    assert query.meta.offset == 31
  end

  test "create and fetch a relation" do
    user_followers
    |> Red.add!({:user, 21})

    followers =
      user_followers
      |> Enum.to_list

    assert followers == ["user#21"]
  end

  test "fetch with limit" do
    user_followers
    |> Red.add!([{:user, 21}, "user#30", "root"])

    followers =
      user_followers
      |> Red.limit(2)
      |> Enum.to_list

    assert length(followers) == 2
  end

end

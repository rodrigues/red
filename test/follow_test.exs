defmodule Follow do
  def followers(id) do
    id
    |> user_entity
    |> Red.relation(:follow, :in)
  end

  def following(id) do
    id
    |> user_entity
    |> Red.relation(:follow, :out)
  end

  def followers_count(id) do
    id
    |> followers
    |> Enum.count
  end

  def following_count(id) do
    id
    |> following
    |> Enum.count
  end

  def following?(following_id, follower_id) do
    follower_id
    |> followers
    |> Enum.member?(following_id |> user_entity)
  end

  def followed_by?(follower_id, following_id) do
    following_id
    |> following?(follower_id)
  end

  def create(following_id, follower_id) do
    following_id
    |> following
    |> Red.add!(follower_id |> user_entity)
  end

  defp user_entity(id), do: {:user, id}
end

defmodule FollowTest do
  use ExUnit.Case
  import Follow

  setup do
    Red.Client.exec([], "FLUSHDB")
    :ok
  end

  test "follow example" do
    {:ok, _} = create(1, 2) # user#1 ~> follow ~> user#2
    {:ok, _} = create(3, 2) # user#3 ~> follow ~> user#2

    followers(2)
    |> Red.add!({:user, 42})

    assert following(1) |> Enum.to_list == ~w(user#2)
    assert following(2) |> Enum.to_list == []
    assert followers(2) |> Enum.to_list == ~w(user#42 user#3 user#1)

    assert following?(1, 2)
    assert followed_by?(2, 1)
    assert following?(3, 2)

    assert followers_count(1) == 0
    assert followers_count(2) == 3
    assert followers_count(3) == 0

    assert following_count(1) == 1
    assert following_count(2) == 0
    assert following_count(3) == 1
  end
end

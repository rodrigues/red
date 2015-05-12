Red
===

[![Build status](https://img.shields.io/travis/rodrigues/red.svg "Build status")](https://travis-ci.org/rodrigues/red)
[![Hex version](https://img.shields.io/hexpm/v/red.svg "Hex version")](https://hex.pm/packages/red)
![Hex downloads](https://img.shields.io/hexpm/dt/red.svg "Hex downloads")

Persist relationships between objects in Redis, in a graph-like way.

**Note**: at this point, highly experimental. Not ready for production.

![](http://plusredelixir.com/wp-content/uploads/2012/02/new-power-elixir-can1.png)

### Relations

```elixir

defmodule Followers do

  def following(user) do
    user
      |> Red.rel(:in, :follow)
  end

  def followed_by(user) do
    user
      |> Red.rel(:out, :follow)
  end

  def common_following(users) do
    users
      |> Stream.map &(following &1)
      |> Red.intersect
  end

  def common_followed_by(users) do
    users
      |> Stream.map &(followed_by &1)
      |> Red.intersect
  end

end

{:user, 42}
  |> Followers.following
  |> Red.limit(20)
  |> Red.fetch!

=> [21, 666, 57]

[{:user, 42}, {:user, 12}]
  |> Followers.common_following
  |> Red.limit(5)
  |> Red.fetch!
=> [21]

i_follow = {:user, 21}
  |> Followers.followed_by

{:user, 42}
  |> Followers.followed_by
  |> Red.sort_by(i_follow)
  |> Red.fetch!

```

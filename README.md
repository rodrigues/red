Red
===

[![Hex version](https://img.shields.io/hexpm/v/red.svg "Hex version")](https://hex.pm/packages/red)
[![Build status](https://img.shields.io/travis/rodrigues/red.svg "Build status")](https://travis-ci.org/rodrigues/red)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/rodrigues/red.svg)](https://beta.hexfaktor.org/github/rodrigues/red)
[![Inline docs](http://inch-ci.org/github/rodrigues/red.svg?branch=master&style=flat)](http://hexdocs.pm/red)
![Hex downloads](https://img.shields.io/hexpm/dt/red.svg "Hex downloads")

Store relations between entities using [redis](http://redis.io).

## Example: A `follow` system

```elixir
import Red

# @vcr2 -{follow}-> @hex_pm

{:ok, _} =
  "@vcr2"
  |> relation(:follow)
  |> add!("@hex_pm")

"@vcr2" |> relation(:follow) |> Enum.at(0)
> "@hex_pm"

# @vcr2 ===follow===> *
count_following = "@vcr2" |> relation(:follow) |> Enum.count
> 100

# @vcr2 <===follow=== *
count_followers = "@vcr2" |> relation(:follow, :in) |> Enum.count
> 43

# jump 10, next 5
"@vcr2" |> relation(:follow) |> offset(10) |> limit(5) |> Enum.to_list
> []
```

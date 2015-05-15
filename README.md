Red
===

[![Build status](https://img.shields.io/travis/rodrigues/red.svg "Build status")](https://travis-ci.org/rodrigues/red)
[![Inline docs](http://inch-ci.org/github/rodrigues/red.svg?branch=master&style=flat)](http://inch-ci.org/github/rodrigues/red)
[![Hex version](https://img.shields.io/hexpm/v/red.svg "Hex version")](https://hex.pm/packages/red)
![Hex downloads](https://img.shields.io/hexpm/dt/red.svg "Hex downloads")

Persist relationships between objects in Redis, in a graph-like way.

## Examples of what can be done now with `Red`

```elixir
# gets 3 most recent users followed by user 42
"user#42"
  |> Red.rel(:follow)
  |> Red.limit(3)
  |> Enum.to_list


# gets all users that follow by user 42
"user#42"
  |> Red.rel(:follow, :in)
  |> Enum.to_list

=> ["user#20", "user#22", "user#30"]

# makes user 42 follow user 21
"user#42"
  |> Red.rel(:follow)
  |> Red.add!("user#21")
```

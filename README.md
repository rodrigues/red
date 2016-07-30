Red
===

[![Build status](https://img.shields.io/travis/rodrigues/red.svg "Build status")](https://travis-ci.org/rodrigues/red)
[![Inline docs](http://inch-ci.org/github/rodrigues/red.svg?branch=master&style=flat)](http://inch-ci.org/github/rodrigues/red)
[![Hex version](https://img.shields.io/hexpm/v/red.svg "Hex version")](https://hex.pm/packages/red)
![Hex downloads](https://img.shields.io/hexpm/dt/red.svg "Hex downloads")

Persists relations between entities in Redis.

## Examples of what can be done now with `Red`

```elixir
# gets all users followed by user 42
"user#42"
|> Red.rel(:follow, :out)
|> Enum.to_list

# gets all users that follow user 42
"user#42"
|> Red.rel(:follow, :in)
|> Enum.to_list

# limits and offsets
"user#42"
|> Red.rel(:follow) # default is :out
|> Red.offset(2)
|> Red.limit(3)
|> Enum.to_list

# creates edge (user#42–> :follow –> user#21)
"user#42"
|> Red.rel(:follow)
|> Red.add!("user#21")

# creates multiple edges from user#42
"user#42"
|> Red.rel(:follow)
|> Red.add!(["user#21", "user#12", "user#15"])
```

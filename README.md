Red
===

[![Hex version](https://img.shields.io/hexpm/v/red.svg "Hex version")](https://hex.pm/packages/red)
[![Build status](https://img.shields.io/travis/rodrigues/red.svg "Build status")](https://travis-ci.org/rodrigues/red)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/rodrigues/red.svg)](https://beta.hexfaktor.org/github/rodrigues/red)
[![Inline docs](http://inch-ci.org/github/rodrigues/red.svg?branch=master&style=flat)](http://hexdocs.pm/red)
![Hex downloads](https://img.shields.io/hexpm/dt/red.svg "Hex downloads")


Persists relations between entities in Redis.

## Examples of what can be done now with `Red`

```elixir
# gets all users followed by user 42
"user#42"
|> Red.relation(:follow, :out)
|> Enum.to_list

# gets all users that follow user 42
"user#42"
|> Red.relation(:follow, :in)
|> Enum.to_list

# limits and offsets
"user#42"
|> Red.relation(:follow) # default is :out
|> Red.offset(2)
|> Red.limit(3)
|> Enum.to_list

# creates edge (user#42–> :follow –> user#21)
"user#42"
|> Red.relation(:follow)
|> Red.add!("user#21")

# creates multiple edges from user#42
"user#42"
|> Red.relation(:follow)
|> Red.add!(["user#21", "user#12", "user#15"])
```

defmodule Red.Query.Meta do
  defstruct offset: 0, limit: -1

  @moduledoc """
  The struct `%Red.Query.Meta{}` contains query parameters
  important for paginating results: _offset_ and _limit_
  """
end

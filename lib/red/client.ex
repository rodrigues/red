defmodule Red.Client do
  @spec exec([String.t|number], String.t) :: {atom, String.t}
  def exec(args, command) do
    redis
    |> Exredis.query([command | args])
    |> parse
  end

  def pipeline_exec(ops) do
    redis
    |> Exredis.query_pipe(ops)
    |> Enum.map(&parse &1)
  end

  def redis, do: Exredis.start

  defp parse(result), do: {:ok, result}
end

defmodule Red.Client do
  @spec exec([String.t|number], String.t) :: {atom, String.t}
  def exec(args, command) do
    redis
    |> Redix.command([command | args])
  end

  def pipeline_exec(ops) do
    redis
    |> Redix.pipeline(ops)
  end

  def redis do
    {:ok, conn} = Redix.start_link
    conn
  end
end

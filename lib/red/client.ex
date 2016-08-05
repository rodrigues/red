defmodule Red.Client do
  @type args :: [String.t | number, ...] | (String.t | number)

  @type redix_result :: {:ok, Redix.Protocol.redis_value} |
                        {:error, atom | Redix.Error.t}

  @spec exec(args, String.t) :: redix_result
  def exec(args, command) when is_list(args) do
    redis
    |> Redix.command([command] ++ args)
  end

  def exec(args, command), do: exec([args], command)

  @spec exec!(args, String.t) :: Redix.Protocol.redis_value
  def exec!(args, command) do
    {:ok, result} = exec(args, command)
    result
  end

  @spec pipeline_exec([args]) :: redix_result
  def pipeline_exec(ops) when is_list(ops) do
    redis
    |> Redix.pipeline(ops)
  end

  @spec redis() :: pid
  def redis do
    {:ok, conn} = Redix.start_link
    conn
  end
end

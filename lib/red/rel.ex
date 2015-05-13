defmodule Red.Rel do

  defstruct name: nil, direction: :out, node: nil

  def key(%Red.Rel{} = rel) do
    "#{Red.Node.key(rel.node)}:#{rel.name}:#{rel.direction}"
  end

end

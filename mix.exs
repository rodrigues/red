defmodule Red.Mixfile do
  use Mix.Project

  def project do
    [app: :red,
     version: "0.0.4",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     description: description,
     package: package]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:exredis, ">= 0.1.1"},
     {:inch_ex, only: :docs}]
  end

  defp description do
    """
    Red is an Elixir library that uses Redis to persist relationships between objects, like a graph.
    """
  end

  defp package do
    [contributors: ["Victor Rodrigues"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/rodrigues/red"},
     files: ~w(mix.exs README.md lib)]
  end
end

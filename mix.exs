defmodule Red.Mixfile do
  use Mix.Project

  def project do
    [app: :red,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,

     # Hex
     description: description,
     package: package]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    []
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

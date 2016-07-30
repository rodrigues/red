defmodule Red.Mixfile do
  use Mix.Project

  def project do
    [app: :red,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,

     description: "Persists relations between entities in Redis",

     package: [contributors: ["Victor Rodrigues"],
               licenses: ["Apache 2.0"],
               links: %{"GitHub" => "https://github.com/rodrigues/red"},
               files: ~w(mix.exs README.md lib)]]
  end

  def application do
    [applications: [:logger, :redix]]
  end

  defp deps do
    [{:redix,    "~> 0.4.0"},
     {:ex_doc,   "~> 0.13.0", only: :dev},
     {:credo,    "~> 0.4.7",  only: :dev},
     {:dialyxir, "~> 0.3.5",  only: :dev}]
  end
end

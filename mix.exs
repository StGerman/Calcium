defmodule Calcium.Mixfile do
  use Mix.Project

  def project do
    [app: :calcium,
     version: "0.1.0",
     elixir: "~> 1.5",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: Calcium],
     deps: deps()]
  end

  def application do
    [extra_applications: apps(Mix.env)]
  end

  defp apps(:dev), do: [:dotenv | apps]
  defp apps(_), do: apps
  defp apps, do: [:logger, :websockex]

  defp deps do
    [
      {:dotenv, "~> 2.0.0"},
      {:websockex, "~> 0.4.0"},
      {:poison, "~> 3.1"}
    ]
  end
end

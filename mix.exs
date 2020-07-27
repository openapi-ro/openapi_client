defmodule OpenapiClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :openapi_client,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.3.0"},
      {:jason, "~> 1.0"}
    ] ++ openapi_deps([:oaex])
  end
  def openapi_deps(packages) do
    Enum.map(packages, &(openapi_dep(Mix.env, &1)))
  end
  def openapi_dep(:prod, package) when is_atom(package) do
    {package, git: "git@github.com:openapi-ro/#{package}.git"}
  end
  def openapi_dep(:test, package)  when is_atom(package)do
    {package, path: "../#{package}", env: :dev}
  end
  def openapi_dep(env, package)  when is_atom(package)do
    {package, path: "../#{package}", env: env}
  end
end

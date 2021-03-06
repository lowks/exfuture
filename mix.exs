defmodule ExFuture.Mixfile do
  use Mix.Project

  def project do
    [ app: :exfuture,
      version: "0.0.1",
      elixir: ">= 1.0.0",
      deps: deps(Mix.env),
      test_coverage: [tool: ExCoveralls] ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:http_server] ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  def deps(:test) do
    deps(:dev)
  end

  def deps(:dev) do
    deps(:prod) ++
      [ {:httpotion, github: "myfreeweb/httpotion"},
        {:http_server, github: "parroty/http_server"},
        {:excoveralls, github: "parroty/excoveralls"} ]
  end

  def deps(:prod) do
    []
  end
end

import Config

config :libcluster,
  topologies: [
    local_epmd: [
      strategy: Elixir.Cluster.Strategy.LocalEpmd
    ]
  ]

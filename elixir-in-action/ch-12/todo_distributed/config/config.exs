# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :todo, :database, pool_size: 3, folder: "./persist"
config :todo, port: 5454

import_config "#{Mix.env()}.exs"

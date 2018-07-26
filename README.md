# BbLearnRestClient 0.1
See BLACKBOARD_LICENSE.md for the license pertaining to the portions of this
package specific to Blackboard Learn.

BbLearnRestClient is an Elixir Hex Package, making it easy to add
Learn REST API calls to your Elixir Application. This first draft is a
first step toward an Blackboard Learn REST SDK for Elixir. The first draft
depends on HTTPoison to make calls to a Learn server, and Poison to 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bblearn_rest_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bblearn_rest_client, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bblearn_rest_client](https://hexdocs.pm/bblearn_rest_client).

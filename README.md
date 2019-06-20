# BbLearnRestClient 0.1
See BLACKBOARD_LICENSE.md for the license pertaining to the portions of this
package specific to Blackboard Learn.

BbLearnRestClient is an Elixir Hex Package, making it easy to add
Learn REST API calls to your Elixir Application. This first draft is a
first step toward an Blackboard Learn REST SDK for Elixir. The first draft
depends on HTTPoison to make calls to a Learn server, and Poison to 

## Use directly from the interactive Elixir Shell:
After cloning...
cd bblearn_rest_client
mix deps get
iex -S mix
alias Learn.RestClient
alias Learn.Api
rc = RestClient.new("bd-partner-a-original.blackboard.com", "your_app_key_here", "your_app_secret_here")
rcauth = RestClient.authorize(rc)
{status, response} = Api.Users.get_user("userName:mkauffman") # Gets the User object for the user mkauffman


## Installation

Once [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bblearn_rest_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bblearn_rest_client, "~> 0.1.0"}
  ]
end
```

## Documentation
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bblearn_rest_client](https://hexdocs.pm/bblearn_rest_client).

## Testing
Run tests from shell prompt after setting environment variables. For example:
export APP_KEY=61e08054-8a00-4790-bd49-07a07e7d82aa
export APP_SECRET=N0n0fyourb1zCAD
export LEARN_SERVER=502.hopto.org

mix test
OR 
mix test --only create_enroll_destroy
  


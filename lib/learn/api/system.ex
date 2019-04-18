defmodule Learn.Api.System do
  require IEx
  @moduledoc """
  Learn.Api.System
  """
  alias Learn.Api.System
  alias Learn.RestUtil

  import HTTPoison
  import Poison

  @v1_system_version  "/learn/api/public/v1/system/version"                     # Since: 3000.3.0

## SYSTEM

  @doc """
  Get the Learn version information.
  Example use:
   iex(5)> {code, response} = Learn.RestClient.get_system_version(rc)
  """
  def get_system_version(rest_client) do
    # GET /learn/api/public/v1/system/version
    url = "https://#{rest_client.fqdn}#{@v1_system_version}"
    {code, response} = HTTPoison.get url
    {code, response}
  end


end

defmodule Learn.Api.Lti do
  require IEx
  @moduledoc """
  Learn.Api.Lti
  """
  alias Learn.Api.Lti
  alias Learn.RestUtil

  import HTTPoison
  import Poison

  @v1_lti_placements "/learn/api/public/v1/lti/placements"                      # Since: 3300.0.0

## LTI
  ## Functions that call the @v1_lti endpoints

  def get_v1_lti_placements(rest_client, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_lti_placements}?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {code, response} = HTTPoison.get url, headers, options
    {code, response}
  end

## LTI convenience functions that call the current version

  def get_lti_placements(rest_client, params \\ %{}) do
    {code, response} = get_v1_lti_placements(rest_client, params)
    {code, response}
  end

end

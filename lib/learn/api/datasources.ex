defmodule Learn.Api.Datasources do
  require IEx
  @moduledoc """
  Learn.Api.Datasources
  """

  @v1_dataSources "/learn/api/public/v1/dataSources"                            # Since: 3000.1.0

   ## DATASOURCES

  ## Functions that call the @v1_dataSources endpoints
  def get_dataSources(rest_client, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_dataSources}?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {status, response} = HTTPoison.get url, headers, options
    {status, response}
  end

end

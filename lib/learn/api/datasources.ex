defmodule Learn.Api.Datasources do
  require IEx
  @moduledoc """
  Learn.Api.Datasources

  Example:
  iex(6)> {status, response} = Api.Datasources.get_datasource(rcauth,"_1_1")
  {:ok,
  %HTTPoison.Response{
    body: "{\"id\":\"_1_1\",\"externalId\":\"INTERNAL\",\"description\":\"Internal data source used for associating records that are created for use by the Bb system.\"}",
  iex(7)> datasource = Learn.Datasource.new_from_json(response.body)
    %Learn.Datasource{
      description: "Internal data source used for associating records that are created for use by the Bb system.",
      externalId: "INTERNAL",
      id: "_1_1"
    }

  """

  @v1_dataSources "/learn/api/public/v1/dataSources"                            # Since: 3000.1.0

   ## DATASOURCES

  ## Functions that call the @v1_dataSources endpoints
  def delete_datasource(rest_client, data_source_id, params \\ %{}, options \\ []) do
    {status, response} = Learn.RestClient.delete_endpoint(rest_client, "#{@v1_dataSources}", data_source_id, params, options)
    {status, response}
  end

  def get_datasource(rest_client, datasourceId, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_dataSources}/#{datasourceId}?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {status, response} = HTTPoison.get url, headers, options
    {status, response}
  end

  def get_datasources(rest_client, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_dataSources}?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {status, response} = HTTPoison.get url, headers, options
    {status, response}
  end

  @doc """
    Call the v1_dateSources endpoint to update the datasource.
  """
  def patch_datasource(rest_client, data_source_id, datasource, params \\ %{}, options \\ []) do
    {status, response} = Learn.RestClient.patch_endpoint(rest_client, "#{@v1_dataSources}", data_source_id, datasource, params, options)
    {status, response}
  end

  def post_datasource(rest_client, datasource, params \\ %{}, options \\ []) do

    {status, response} = Learn.RestClient.post_endpoint(rest_client, "#{@v1_dataSources}", datasource, params, options)
    {status, response}
  end

end

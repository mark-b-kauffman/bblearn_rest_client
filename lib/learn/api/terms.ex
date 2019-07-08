defmodule Learn.Api.Terms do
  require IEx
  @moduledoc """
  Learn.Api.Terms

  Example:
  iex(6)> {status, response} = Api.Terms.get_term(rcauth,"_1_1")

  """

  @v1_terms "/learn/api/public/v1/terms"                            # Since: 3000.1.0

   ## Terms

  ## Functions that call the @v1_terms endpoints
  def delete_term(rest_client, data_source_id, params \\ %{}, options \\ []) do
    {status, response} = Learn.RestClient.delete_endpoint(rest_client, "#{@v1_terms}", data_source_id, params, options)
    {status, response}
  end

  def get_term(rest_client, termId, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_terms}/#{termId}?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {status, response} = HTTPoison.get url, headers, options
    {status, response}
  end

  def get_terms(rest_client, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_terms}?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {status, response} = HTTPoison.get url, headers, options
    {status, response}
  end

  @doc """
    Call the v1_dateSources endpoint to update the term.
  """
  def patch_term(rest_client, data_source_id, term, params \\ %{}, options \\ []) do
    {status, response} = Learn.RestClient.patch_endpoint(rest_client, "#{@v1_terms}", data_source_id, term, params, options)
    {status, response}
  end

  def post_term(rest_client, term, params \\ %{}, options \\ []) do

    {status, response} = Learn.RestClient.post_endpoint(rest_client, "#{@v1_terms}", term, params, options)
    {status, response}
  end

end

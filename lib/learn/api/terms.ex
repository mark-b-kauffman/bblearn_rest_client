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

  @doc """
    These next two functions are similar. Having two is a nicety for the English language
    Call the v1_terms endpoint to get a term, or terms.
  """
  def get_term(rest_client, term_id, params \\ %{}, options \\ []) do

    {status, response} = Learn.RestClient.get_endpoint(rest_client, "#{@v1_terms}", term_id, params, options)
    {status, response}
  end

  def get_terms(rest_client, params \\ %{}, options \\ []) do
    term_id = ""
    {status, response} = Learn.RestClient.get_endpoint(rest_client, "#{@v1_terms}", term_id, params, options)
    {status, response}
  end

  @doc """
    Call the v1_terms endpoint to update the term.
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

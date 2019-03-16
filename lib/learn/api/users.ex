defmodule Learn.Api.Users do
  require IEx
  @moduledoc """
  Learn.Api.Courses
  """
  alias Learn.Api.Users
  alias Learn.RestUtil

  import HTTPoison
  import Poison

  @v1_users "/learn/api/public/v1/users"                                        # Since: 3000.1.0

   ## USERS

  ## Functions that call the v1_users endpoint
  def get_user(rest_client, user_id) do
    url = "https://#{rest_client.fqdn}#{@v1_users}/#{user_id}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {code, user_model} = case {code, response} = HTTPoison.get url, headers, options do
      {:ok, _} ->  Poison.decode(response.body)
      {_, _} -> raise("rest_client: #{inspect rest_client} code: #{Atom.to_string(code)} response: #{inspect response}")
    end
  end

  @doc """
    Call the v1_users endpoint, include a map of the parameters that is turned
    into a parameter list and attached to the URL we make the request to.
  """
  def get_users(rest_client, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_users}?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {code, response} = HTTPoison.get url, headers, options
  end

  def get_users_courses(rest_client, user_id) do
    url = "https://#{rest_client.fqdn}#{@v1_users}/#{user_id}/courses"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {code, response} = HTTPoison.get url, headers, options
  end

end

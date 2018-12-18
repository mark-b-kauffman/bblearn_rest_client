defmodule Learn.Api.Courses do
  require IEx
  @moduledoc """
  Learn.Api.Courses
  """
  alias Learn.Api.Courses
  alias Learn.RestUtil

  import HTTPoison
  import Poison

  @v1_courses "/learn/api/public/v1/courses"                                    # Since: 3000.1.0
  @v2_courses "/learn/api/public/v2/courses"                                    # Since: 3400.8.0

    ## COURSES

  ## Functions that call the v1_courses endpoint
  def get_v1_course(rest_client, course_id) do
    url = "https://#{rest_client.fqdn}#{@v1_courses}/#{course_id}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {code, response} = HTTPoison.get url, headers, options
  end

  @doc """
    Call the v1_courses endpoint, include a map of the parameters that is turned
    into a parameter list and attached to the URL we make the request to.
  """
  def get_v1_courses(rest_client, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_courses}?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {code, response} = HTTPoison.get url, headers, options
  end

  ## Functions that call the v2_courses endpoint

  def get_v2_course(rest_client, course_id) do
    url = "https://#{rest_client.fqdn}#{@v2_courses}/#{course_id}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {code, response} = HTTPoison.get url, headers, options
  end

  @doc """
    Call the v2_courses endpoint, include a map of the parameters that is turned
    into a parameter list and attached to the URL we make the request to.
  """
  def get_v2_courses(rest_client, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v2_courses}?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {code, response} = HTTPoison.get url, headers, options
  end

  ## COURSES convenience methods to call the latest version
  def get_course(rest_client, course_id) do

    {code, course} = case {code, response} = get_v2_course(rest_client, course_id) do
      {:ok, response} -> {:ok, course} = Poison.decode(response.body)
      {_, response } -> raise("rest_client: #{inspect rest_client} code: #{Atom.to_string(code)} response: #{inspect response}")
    end
    case {code, course}  do
      {:ok, course} -> {:ok, Learn.RestUtil.to_struct(Learn.Course, course)}
      {_, _} -> raise("rest_client: #{inspect rest_client} code: #{Atom.to_string(code)} course: #{inspect course}")
    end
  end

  @doc """
    Call the latest v_ courses endpoint, include a map of the parameters that is turned
    into a parameter list and attached to the URL we make the request to.
  """
  def get_courses(rest_client, params \\ %{}) do
    {code, response} = get_v2_courses(rest_client, params )
  end

end

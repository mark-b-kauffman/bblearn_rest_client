defmodule Learn.Api.CoursesUsers do
  require IEx
  @moduledoc """
  Learn.Api.CoursesUsers
  """
  alias Learn.Api.CoursesUsers
  alias Learn.RestUtil

  import HTTPoison
  import Poison

  @v1_courses "/learn/api/public/v1/courses"                                    # Since: 3000.1.0
  @v2_courses "/learn/api/public/v2/courses"                                    # Since: 3400.8.0


  ## COURSES USERS
  @doc """
    Call the v1_courses endpoint to get a course's users,
    include a map of the parameters that is turned
    into a parameter list and attached to the URL we make the request to.
  """
  def get_v1_courses_users(rest_client, courseId, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_courses}/#{courseId}/users?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {code, response} = HTTPoison.get url, headers, options
  end

  ## course memberships convenience methods to call the lastest version
  def get_courses_users(rest_client, courseId, params \\ %{}) do
    {code, response} = get_v1_courses_users(rest_client, courseId, params)
  end


end

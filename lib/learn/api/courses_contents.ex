defmodule Learn.Api.CoursesContents do
  require IEx
  @moduledoc """
  Learn.Api.CoursesContents
  """

  @v1_courses "/learn/api/public/v1/courses"                                    # Since: 3000.1.0
##  @v2_courses "/learn/api/public/v2/courses"                                    # Since: 3400.8.0

   ## COURSES CONTENTS as of 2019.05.24 contents endpoint is all v1.
  @doc """
    Call the v1_courses endpoint to get it's top-level content items.
  """
  def get_v1_courses_contents(rest_client, courseId, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_courses}/#{courseId}/contents?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {status, response} = HTTPoison.get url, headers, options
    {status, response}
  end

  @doc """
    Convenience method to call the latest v of get_courses_contents
  """
  def get_courses_contents(rest_client, courseId, params \\ %{}) do
    get_v1_courses_contents(rest_client, courseId, params )
  end

  @doc """
    Call the v1_courses endpoint to get it's contentId's child content items.
  """
  def get_v1_courses_contents_children(rest_client, courseId, contentId, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_courses}/#{courseId}/contents/#{contentId}/children?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {status, response} = HTTPoison.get url, headers, options
    {status, response}
  end

   @doc """
    Convenience method to call the latest v endpoint to get it's contentId's child content items.
  """
  def get_courses_contents_children(rest_client, courseId, contentId, params \\ %{}) do
    get_v1_courses_contents_children(rest_client, courseId, contentId, params)
  end

  @doc """
    POST to the v1_courses endpoint to add to one of its contentId's child content items.
  """
  def post_v1_courses_contents_children(rest_client, courseId, contentId, course_contents_body, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_courses}/#{courseId}/contents/#{contentId}/children?#{paramlist}"
    body = Poison.encode!(course_contents_body)
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {status, response} = HTTPoison.post url, body, headers, options
    {status, response}
  end

end

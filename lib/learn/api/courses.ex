defmodule Learn.Api.Courses do
  require IEx
  @moduledoc """
  Learn.Api.Courses

  JSON for v1 POST COURSE Announcement
  {
  "title": "string",
  "body": "<!-- {\"bbMLEditorVersion\":1} --><div data-bbid=\"bbml-editor-id_9c6a9556-80a5-496c-b10d-af2a9ab22d45\"> <h4>Header Large</h4>  <h5>Header Medium</h5>  <h6>Header Small</h6>  <p><strong>Bold&nbsp;</strong><em>Italic&nbsp;<span style=\"text-decoration: underline;\">Italic Underline</span></em></p> <ul>   <li><span style=\"text-decoration: underline;\"><em></em></span>Bullet 1</li>  <li>Bullet 2</li> </ul> <p>  <img src=\"@X@EmbeddedFile.requestUrlStub@X@bbcswebdav/xid-1217_1\">   <span>\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\"</span> </p>  <p><span>&lt;braces test=\"values\" other=\"strange things\"&gt;</span></p> <p>Header Small</p> <ol>   <li>Number 1</li>   <li>Number 2</li> </ol>  <p>Just words followed by a formula</p>  <p><img align=\"middle\" alt=\"3 divided by 4 2 root of 7\" class=\"Wirisformula\" src=\"@X@EmbeddedFile.requestUrlStub@X@sessions/EA5F7FF3DF32D271D0E54AF0150D924A/anonymous/wiris/49728c9f5b4091622e2f4d183d857d35.png\" data-mathml=\"«math xmlns=¨http://www.w3.org/1998/Math/MathML¨»«mn»3«/mn»«mo»/«/mo»«mn»4«/mn»«mroot»«mn»7«/mn»«mn»2«/mn»«/mroot»«/math»\"></p> <p><a href=\"http://www.blackboard.com\">Blackboard</a></p> </div>",
  "draft": true,
  "availability": {
    "duration": {
      "start": "2019-03-18T21:15:09.010Z",
      "end": "2019-03-18T21:15:09.010Z"
      }
    }
  }


  """

  alias Learn.Course
  alias Learn.RestClient


  # import HTTPoison
  # import Poison

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
    {code, response}
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
    {code, response}
  end

  def post_v2_course(rest_client, course, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    body = Poison.encode!(course)
    url = "https://#{rest_client.fqdn}#{@v2_courses}?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {code, response} = HTTPoison.post url, body, headers, options
    {code, response}
  end

  ## COURSES convenience methods to call the latest version
  def get_course(rest_client, course_id) do

    {code, course} = case {code, _} = get_v2_course(rest_client, course_id) do
      {:ok, response} -> {:ok, _} = Poison.decode(response.body)
      {_, response } -> raise("rest_client: #{inspect rest_client} code: #{Atom.to_string(code)} response: #{inspect response}")
    end

    {code, Learn.RestUtil.to_struct(Learn.Course, course)}
  end

  def post_course(rest_client,course, params \\ %{}) do
    {code, rcourse} = case {code, _} = post_v2_course(rest_client, course, params) do
      {:ok, response} -> {:ok, _} = {:ok, Course.new_from_json(response.body) }
      {_, response } -> raise("rest_client: #{inspect rest_client} code: #{Atom.to_string(code)} response: #{inspect response}")
    end
    {code, course}
  end

  @doc """
   GET COURSE Announcements
   the_announcement = %{"title" => "Course Announcement Title", "body" => "Course Announcement Body"}
  """
  def get_announcements(rest_client, course_id, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_courses}/#{course_id}/announcements?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {code, response} = HTTPoison.get url, headers, options
    {code, response}
  end

  @doc """
   POST COURSE Announcement
   the_announcement = %{"title" => "Course Announcement Title", "body" => "Course Announcement Body"}
  """
  def post_announcements(rest_client, course_id, the_announcement,  params \\ %{} ) do
    params = %{offset: 0} |> Map.merge(params)
    url_path = "#{@v1_courses}/#{course_id}/announcements"
    {code, response} = RestClient.post_endpoint(rest_client, url_path, the_announcement, params )
    {code, response}
  end


  @doc """
    Call the latest v_ courses endpoint, include a map of the parameters that is turned
    into a parameter list and attached to the URL we make the request to.
  """
  def get_courses(rest_client, params \\ %{}) do
    {code, response} = get_v2_courses(rest_client, params )
  end


  @doc """
    post_v1_courses_copy(rest_client, course_id, reqCourseObjToConvert, params \\ %{} )
    Call POST /learn/api/public/v1/courses/{courseId}/copy
    {courseId} is the existing course.
    reqCourseObjToConvert is the Elixir representation of the json for the course to copy into.
    iex(35)> x = %{"courseId" => "mbK_514_1"}
    x = %{"courseId" => "mbK_514_1"}
    iex(36)> Poison.encode!(x)
    "{\"courseId\":\"mbK_514_1\"}"
    iex(37)> Api.Courses.post_v1_courses_copy(rcauth, "_514_1", x )
    {:ok,
    %HTTPoison.Response{
     body: "{}",
     headers: [
        {"Cache-Control", "private"},
        {"Cache-Control", "max-age=0"},
        {"Cache-Control", "no-store"},
        {"Cache-Control", "must-revalidate"},
        {"Cache-control", "no-cache=\"set-cookie\""},
        {"Content-Security-Policy", "frame-ancestors 'self'"},
        {"Content-Type", "application/json;charset=UTF-8"},
        {"Date", "Fri, 15 Mar 2019 22:06:46 GMT"},
        {"Expires", "Thu, 15 Mar 2018 22:06:45 GMT"},
        {"Last-Modified", "Mon, 15 Mar 1999 23:06:45 GMT"},
        {"Location", "/learn/api/public/v1/courses/_657_1/tasks/_6877_1"}, <-- track the copy progress
  """
  def post_v1_courses_copy(rest_client, course_id, reqCourseObjToConvert, params \\ %{} ) do
    params = %{offset: 0} |> Map.merge(params)
    url_path = "#{@v1_courses}/#{course_id}/copy"
    {code, response} = RestClient.post_endpoint(rest_client, url_path, reqCourseObjToConvert, params )
    {code, response}
  end

end

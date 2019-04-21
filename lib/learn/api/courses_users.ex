defmodule Learn.Api.CoursesUsers do
  require IEx
  @moduledoc """
  Learn.Api.CoursesUsers
  iex(25)> {code, response} =
    Api.CoursesUsers.get_course_user(rcauth, "courseId:mbk-original", "userName:mkauffman-new1", %{expand: "user"})

  iex(26)> my_cu_json = Learn.CourseUser.new_from_json(response.body)
    %Learn.CourseUser{
      availability: %{"available" => "Yes"},
      childCourse: nil,
      course: nil,
      courseId: "_7_1",
      courseRoleId: "Student",
      dataSourceId: "_2_1",
      user: %{
        "availability" => %{"available" => "Yes"},
        "contact" => %{"email" => "markkauffman2000@gmail.com"},
        "created" => "2019-04-17T23:58:04.285Z",
        "dataSourceId" => "_2_1",
        "educationLevel" => "Unknown",
        "externalId" => "mkauffmannew1",
        "gender" => "Male",
        "id" => "_6_1",
        "name" => %{"family" => "KauffmanNew1", "given" => "Mark"},
        "studentId" => "mkauffman",
        "userName" => "mkauffman-new1",
        "uuid" => "4c59b447c2704141b592d37ccf824ee0"
      },
      userId: "_6_1"
    }
  """

  @v1_courses "/learn/api/public/v1/courses"                                    # Since: 3000.1.0


  ## COURSES USERS
  @doc """
    Delete the course user
  """
  def delete_v1_courses_users(rest_client, courseId, userId, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_courses}/#{courseId}/users/#{userId}?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {code, response} = HTTPoison.delete url, headers, options
    {code, response}
  end

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
    {code, response}
  end

  ## course memberships convenience methods to call the lastest version
  def get_courses_users(rest_client, courseId, params \\ %{}) do
    {code, response} = get_v1_courses_users(rest_client, courseId, params)
    {code, response}
  end

  def get_v1_course_user(rest_client, courseId, userId, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_courses}/#{courseId}/users/#{userId}?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {code, response} = HTTPoison.get url, headers, options
    {code, response}
  end

  def get_course_user(rest_client, courseId, userId, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    {code, response} = get_v1_course_user(rest_client, courseId, userId, params)
    {code, response}
  end


  def post_v2_courses_users(rest_client, course_id, user_id, child_course \\ %{}, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    body = Poison.encode!(child_course)
    url = "https://#{rest_client.fqdn}#{@v1_courses}/#{course_id}/users/#{user_id}?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {code, response} = HTTPoison.put url, body, headers, options
    {code, response}
  end

  def post_courses_users(rest_client, course_id, user_id, child_course \\ %{}, params \\ %{} ) do
    {code, response} = post_v2_courses_users(rest_client, course_id, user_id, child_course, params)
    {code, response}
  end


end

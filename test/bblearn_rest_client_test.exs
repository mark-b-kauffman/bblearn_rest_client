defmodule BblearnRestClientTest do

  use ExUnit.Case
  alias Learn.RestClient
  alias Learn.Api
  doctest BblearnRestClient

  # See config.exs app_key and app_secret are environment APP_KEY & APP_SECRET
  # Now we have a way to get access and test! Also need LEARN_SERVER
  # Run a single test with: mix test --only <test name>
  @app_key Application.get_env(:bblearn_rest_client, :oauth)[:app_key]
  @app_secret Application.get_env(:bblearn_rest_client, :oauth)[:app_secret]
  @learn_server Application.get_env(:bblearn_rest_client, :oauth)[:learn_server]

  setup_all do
    IO.puts "If you run into errors be certain to have set these environment variables: APP_KEY, APP_SECRET, and LEARN_SERVER."
  end

  @tag :greet
  test "greets the world" do
    IO.puts "test: greets the world"
    assert BblearnRestClient.hello() == "Use lib/learn/rest_client."
  end

  # Bash command to repeatedly authorize and watch the POST to the endpoint show up when the token is stale:
  # for i in {1..600}; do date | tee -a authtestlog.txt; mix test --only authorize | tee -a authtestlog.txt; sleep 1; done
  @tag :authorize
  @tag timeout: 100000
  test "authorize" do
    IO.puts "test: authorize"
    rc = RestClient.new(@learn_server, @app_key, @app_secret)
    assert Map.has_key?(rc, :fqdn) == true
    assert Map.has_key?(rc, :key) == true
    assert Map.has_key?(rc, :secret) == true
    assert Map.has_key?(rc, :token) == true
    rcauth = RestClient.authorize(rc)
    IO.puts "-rcauth.token-"
    IO.inspect(rcauth.token)
    :timer.sleep(10000)
    rcauth2 = RestClient.authorize(rcauth)
    IO.puts "--rcauth2.token--"
    IO.inspect(rcauth2.token)
    :timer.sleep(10000)
    rcauth3 = RestClient.authorize(rcauth)
    IO.puts "--rcauth3.token--"
    IO.inspect(rcauth3.token)
    :timer.sleep(10000)
    rcauth4 = RestClient.authorize(rcauth)
    IO.puts "--rcauth4.token--"
    IO.inspect(rcauth4.token)
    :timer.sleep(10000)
    rcauth5 = RestClient.authorize(rcauth)
    IO.puts "--rcauth5.token--"
    IO.inspect(rcauth5.token)
    :timer.sleep(10000)
    rcauth6 = RestClient.authorize(rcauth)
    IO.puts "--rcauth6.token--"
    IO.inspect(rcauth6.token)
    :timer.sleep(10000)
    rcauth7 = RestClient.authorize(rcauth)
    IO.puts "--rcauth7.token--"
    IO.inspect(rcauth7.token)
    assert rcauth.token["token_type"] == "bearer"
  end

  test "get_announcements" do
    IO.puts "test: get_announcements"
    rc = RestClient.new(@learn_server, @app_key, @app_secret)
    assert Map.has_key?(rc, :token) == true
    rcauth = RestClient.authorize(rc)
    assert rcauth.token["token_type"] == "bearer"
    {code, response} = Api.Announcements.get_announcements(rcauth)
    assert code == :ok
    assert response.status_code == 200
  end

  test "get_course" do
    IO.puts "test: get_v1_course"
    rc = RestClient.new(@learn_server, @app_key, @app_secret)
    assert Map.has_key?(rc, :token) == true
    rcauth = RestClient.authorize(rc)
    assert rcauth.token["token_type"] == "bearer"
    {code, response} = Api.Courses.get_course(rcauth, "courseId:mbk-original")
    assert code == :ok
    assert response.status_code == 200

    {code, response} = Api.Courses.get_course(rcauth, "courseId:nocoursehere")
    assert code == :ok
    assert response.status_code == 404
  end

  test "get_courses" do
    IO.puts "test: get_courses"
    rc = RestClient.new(@learn_server, @app_key, @app_secret)
    assert Map.has_key?(rc, :token) == true
    rcauth = RestClient.authorize(rc)
    assert rcauth.token["token_type"] == "bearer"
    {code, response} = Api.Courses.get_courses(rcauth)
    assert code == :ok
    assert response.status_code == 200
  end

  test "get_courses_users" do
    IO.puts "test: get_course_users"
    rc = RestClient.new(@learn_server, @app_key, @app_secret)
    assert Map.has_key?(rc, :token) == true
    rcauth = RestClient.authorize(rc)
    assert rcauth.token["token_type"] == "bearer"
    {code, response} = Api.CoursesUsers.get_course_users(rcauth, "courseId:mbk-original")

    assert code == :ok
    assert response.status_code == 200
  end

  test "get_dataSources" do
    IO.puts "test: get_dataSources"
    rc = RestClient.new(@learn_server, @app_key, @app_secret)
    assert Map.has_key?(rc, :token) == true
    rcauth = RestClient.authorize(rc)
    assert rcauth.token["token_type"] == "bearer"
    {code, response} = Api.Datasources.get_dataSources(rcauth)
    assert code == :ok
    assert response.status_code == 200
  end

  test "get_system_version" do
    IO.puts "test: get_system_version"
    rc = RestClient.new(@learn_server, @app_key, @app_secret)
    assert Map.has_key?(rc, :token) == true
    rcauth = RestClient.authorize(rc)
    assert rcauth.token["token_type"] == "bearer"
    {code, response} = Api.System.get_system_version(rcauth)
    assert code == :ok
    assert response.status_code == 200
  end

  test "get_user" do
    IO.puts "test: get_user"
    rc = RestClient.new(@learn_server, @app_key, @app_secret)
    assert Map.has_key?(rc, :token) == true
    rcauth = RestClient.authorize(rc)
    assert rcauth.token["token_type"] == "bearer"
    # NOTE: We had userName:mkauffman, but that doesn't work unless you have
    # the REST APP configured with a user with the Learn Adamin System role.
    {code, response} = Api.Users.get_user(rcauth, "userName:mkauffman")
    # TODO: debug the phoenixdsk-user system role. It's not pulling the user.
    assert code == :ok
    assert response.status_code == 200

    {code, response} = Api.Users.get_user(rcauth, "userName:nonamehere")
    assert code == :ok
    assert response.status_code == 404
  end

  # Run with mix test --only create_enroll_destroy
  @tag :create_enroll_destroy
  test "create_enroll_destroy" do
    IO.puts "test: create_enroll_destroy course users enrollments"
    rc = RestClient.new(@learn_server, @app_key, @app_secret)
    assert Map.has_key?(rc, :token) == true
    rcauth = RestClient.authorize(rc)
    assert rcauth.token["token_type"] == "bearer"
    # NOTE: We had userName:mkauffman, but that doesn't work unless you have
    # the REST APP configured with a user with the Learn Adamin System role.
    {code, response} = Api.Users.get_user(rcauth, "userName:mkauffman")
    # TODO: debug the phoenixdsk-user system role. It's not pulling the user.
    assert code == :ok
    assert response.status_code == 200
    my_course = %Learn.Course{allowGuests: true, \
    availability: %{"available" => "Yes", "duration" => %{"type" => "Continuous"}},\
     courseId: "mbk-delete1", dataSourceId: "externalId:SYSTEM", \
     enrollment: %{"type" => "InstructorLed"}, \
     name: "Demo Course For Testing Purpose - mbk-delete1", ultraStatus: "Classic"}

    my_user1 = %Learn.User{address: nil, availability: %{"available" => "Yes"}, userName: "mbk-delete-user1", password: "N0n10furb1z",
     dataSourceId: "externalId:SYSTEM", gender: "male", name: %{"family" => "KauffmanDelete1", "given" => "Mark"},\
     externalId: "mkauffmandelete1", institutionRoleIds:  ["FACULTY"], studentId: "mkauffmandelete1" }

    my_user2 = %Learn.User{address: nil, availability: %{"available" => "Yes"}, userName: "mbk-delete-user2", password: "N0n10furb1z",
     dataSourceId: "externalId:SYSTEM", gender: "male", name: %{"family" => "KauffmanDelete2", "given" => "Mark"},\
     externalId: "mkauffmandelete2", institutionRoleIds:  ["FACULTY"], studentId: "mkauffmandelete2" }

    my_user3 = %Learn.User{address: nil, availability: %{"available" => "Yes"}, userName: "mbk-delete-user3", password: "N0n10furb1z",
     dataSourceId: "externalId:SYSTEM", gender: "male", name: %{"family" => "KauffmanDelete3", "given" => "Mark"},\
     externalId: "mkauffmandelete3", institutionRoleIds:  ["FACULTY"], studentId: "mkauffmandelete3" }

    {code, response} = Api.Courses.post_course(rcauth, my_course)
    assert code == :ok
    assert response.status_code == 201

    {code, response} = Api.Users.post_user(rcauth, my_user1)
    assert code == :ok
    assert response.status_code == 201

    {code, response} = Api.Users.post_user(rcauth, my_user2)
    assert code == :ok
    assert response.status_code == 201

    {code, response} = Api.Users.post_user(rcauth, my_user3)
    assert code == :ok
    assert response.status_code == 201

    {code, response} = Api.CoursesUsers.put_course_user(rcauth, "courseId:mbk-delete1", "userName:#{my_user1.userName}")
    assert code == :ok
    assert response.status_code == 201

    {code, response} = Api.CoursesUsers.put_course_user(rcauth, "courseId:mbk-delete1", "userName:#{my_user2.userName}")
    assert code == :ok
    assert response.status_code == 201

    {code, response} = Api.CoursesUsers.put_course_user(rcauth, "courseId:mbk-delete1", "userName:#{my_user3.userName}")
    assert code == :ok
    assert response.status_code == 201

    {code, response} = Api.CoursesUsers.delete_course_user(rcauth, "courseId:mbk-delete1", "userName:#{my_user1.userName}")
    assert code == :ok
    assert response.status_code == 204

    {code, response} = Api.CoursesUsers.delete_course_user(rcauth, "courseId:mbk-delete1", "userName:#{my_user2.userName}")
    assert code == :ok
    assert response.status_code == 204

    {code, response} = Api.CoursesUsers.delete_course_user(rcauth, "courseId:mbk-delete1", "userName:#{my_user3.userName}")
    assert code == :ok
    assert response.status_code == 204

    Api.Users.delete_user(rcauth, "userName:#{my_user1.userName}")
    assert code == :ok
    assert response.status_code == 204

    Api.Users.delete_user(rcauth, "userName:#{my_user2.userName}")
    assert code == :ok
    assert response.status_code == 204

    Api.Users.delete_user(rcauth, "userName:#{my_user3.userName}")
    assert code == :ok
    assert response.status_code == 204

    Api.Courses.delete_course(rcauth, "courseId:#{my_course.courseId}")
    assert code == :ok
    assert response.status_code == 204

    {code, response} = Api.Users.get_user(rcauth, "userName:nowhereman")
    assert code == :ok
    assert response.status_code == 404
  end

end


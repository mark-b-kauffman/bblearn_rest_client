defmodule BblearnRestClientTest do

  use ExUnit.Case
  alias Learn.RestClient
  doctest BblearnRestClient
  # See config.exs app_key and app_secret are environment APP_KEY & APP_SECRET
  # Now we have a way to get access and test! Also need LEARN_SERVER
  @app_key Application.get_env(:bblearn_rest_client, :oauth)[:app_key]
  @app_secret Application.get_env(:bblearn_rest_client, :oauth)[:app_secret]
  @learn_server Application.get_env(:bblearn_rest_client, :oauth)[:learn_server]

  setup_all do
    IO.puts "If you run into errors be certain to have set these environment variables: APP_KEY, APP_SECRET, and LEARN_SERVER."
  end

  test "greets the world" do
    IO.puts "test: greets the world"
    assert BblearnRestClient.hello() == "Use lib/learn/rest_client."
  end

  test "authorize" do
    IO.puts "test: authorize"
    rc = RestClient.new(@learn_server, @app_key, @app_secret)
    assert Map.has_key?(rc, :fqdn) == true
    assert Map.has_key?(rc, :key) == true
    assert Map.has_key?(rc, :secret) == true
    assert Map.has_key?(rc, :token) == true
    rcauth = RestClient.authorize(rc)
    assert rcauth.token["token_type"] == "bearer"
  end

  test "get_announcements" do
    IO.puts "test: get_announcements"
    rc = RestClient.new(@learn_server, @app_key, @app_secret)
    assert Map.has_key?(rc, :token) == true
    rcauth = RestClient.authorize(rc)
    assert rcauth.token["token_type"] == "bearer"
    {code, response} = RestClient.get_announcements(rcauth)
    assert code == :ok
    assert response.status_code == 200
  end

  test "get_course" do
    IO.puts "test: get_v1_course"
    rc = RestClient.new(@learn_server, @app_key, @app_secret)
    assert Map.has_key?(rc, :token) == true
    rcauth = RestClient.authorize(rc)
    assert rcauth.token["token_type"] == "bearer"
    {code, response} = RestClient.get_v1_course(rcauth, "courseId:1")
    assert code == :ok
    assert response.status_code == 200

    {code, response} = RestClient.get_course(rcauth, "courseId:nocoursehere")
    assert code == :ok
    assert response.status_code == 404
  end

  test "get_courses" do
    IO.puts "test: get_courses"
    rc = RestClient.new(@learn_server, @app_key, @app_secret)
    assert Map.has_key?(rc, :token) == true
    rcauth = RestClient.authorize(rc)
    assert rcauth.token["token_type"] == "bearer"
    {code, response} = RestClient.get_courses(rcauth)
    assert code == :ok
    assert response.status_code == 200
  end

  test "get_courses_users" do
    IO.puts "test: get_courses_users"
    rc = RestClient.new(@learn_server, @app_key, @app_secret)
    assert Map.has_key?(rc, :token) == true
    rcauth = RestClient.authorize(rc)
    assert rcauth.token["token_type"] == "bearer"
    {code, response} = RestClient.get_courses_users(rcauth, "courseId:1")

    assert code == :ok
    assert response.status_code == 200
  end

  test "get_dataSources" do
    IO.puts "test: get_dataSources"
    rc = RestClient.new(@learn_server, @app_key, @app_secret)
    assert Map.has_key?(rc, :token) == true
    rcauth = RestClient.authorize(rc)
    assert rcauth.token["token_type"] == "bearer"
    {code, response} = RestClient.get_dataSources(rcauth)
    assert code == :ok
    assert response.status_code == 200
  end

  test "get_system_version" do
    IO.puts "test: get_system_version"
    rc = RestClient.new(@learn_server, @app_key, @app_secret)
    assert Map.has_key?(rc, :token) == true
    rcauth = RestClient.authorize(rc)
    assert rcauth.token["token_type"] == "bearer"
    {code, response} = RestClient.get_system_version(rcauth)
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
    {code, response} = RestClient.get_user(rcauth, "userName:mkauffman-student")
    # TODO: debug the phoenixdsk-user system role. It's not pulling the user.
    assert code == :ok
    assert response.status_code == 200

    {code, response} = RestClient.get_user(rcauth, "userName:nonamehere")
    assert code == :ok
    assert response.status_code == 404
  end

end

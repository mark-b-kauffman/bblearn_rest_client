defmodule BblearnRestClientTest do
  
  use ExUnit.Case
  alias Learn.RestClient
  doctest BblearnRestClient
  # See config.exs app_key and app_secret are environment APP_KEY & APP_SECRET
  # Now we have a way to get access and test! Also need LEARN_SERVER
  @app_key Application.get_env(:bblearn_rest_client, :oauth)[:app_key]
  @app_secret Application.get_env(:bblearn_rest_client, :oauth)[:app_secret]
  @learn_server Application.get_env(:bblearn_rest_client, :oauth)[:learn_server]

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
    IO.puts "test: get_course"
    rc = RestClient.new(@learn_server, @app_key, @app_secret)
    assert Map.has_key?(rc, :token) == true
    rcauth = RestClient.authorize(rc)
    assert rcauth.token["token_type"] == "bearer"
    {code, response} = RestClient.get_course(rcauth, "courseId:1")
    assert code == :ok
    assert response.status_code == 200

    {code, response} = RestClient.get_course(rcauth, "courseId:nocoursehere")
    assert code == :ok
    assert response.status_code == 404
  end


end

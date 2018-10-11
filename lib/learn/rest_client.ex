defmodule Learn.RestClient do
  @moduledoc """
  Learn.RestClient
  Abstraction of Blackboard Learn REST APIs for Elixir.
  We use HTTPoison to make the GET, POST, etc.
  The response is the map returned by HTTPoison, with no other transformation.
  Example (with a call that doesn't require an access token):
    iex> alias Learn.RestClient
    Learn.RestClient
    iex> rc = RestClient.new("bd-partner-a-original.blackboard.com", "d128e50d-c91e-47d3-a97e-9d0c8a77fb5d", "itsasecret")
    %Learn.RestClient{
      token: nil,
      fqdn: "bd-partner-a-original.blackboard.com",
      key: "d128e50d-c91e-47d3-a97e-9d0c8a77fb5d",
      secret: "itsasecret"
    }
    iex> RestClient.get_system_version(rc)
    {:ok,
     %HTTPoison.Response{
       body: "{\"learn\":{\"major\":3400,\"minor\":7,\"patch\":0,\"build\":\"e229b7f\"}}",
       headers: [
         {"Cache-Control", "private"},
         {"Cache-Control", "max-age=0"},
         {"Cache-Control", "no-store"},
         {"Cache-Control", "must-revalidate"},
         {"Cache-control", "no-cache=\"set-cookie\""},
         {"Content-Security-Policy", "frame-ancestors 'self'"},
         {"Content-Type", "application/json;charset=UTF-8"},
         {"Date", "Tue, 12 Jun 2018 22:20:20 GMT"},
         {"Expires", "Mon, 12 Jun 2017 22:20:20 GMT"},
         {"Last-Modified", "Fri, 12 Jun 1998 22:20:20 GMT"},
         {"P3P", "CP=\"CAO PSA OUR\""},
         {"Pragma", "private"},
         {"Server", "openresty/1.9.3.1"},
         {"Set-Cookie",
          "JSESSIONID=AFD0649F770321AA1901EDC1B725304D; Path=/learn/api; Secure"},
         {"Set-Cookie",
          "AWSELB=CBCD31AD08A7A3096F8F703AD8716049AD9FF303B03D2D55A0D8ED44B0746EF79483D7F3E1DED89F13B5250116B84EA8AD909AE02ADEED096228BDFD80D996F40D0B98D919;PATH=/"},
         {"X-Blackboard-appserver", "ip-10-145-92-105.ec2.internal"},
         {"X-Blackboard-Context-Version", "3400.7.0-rel.5+e229b7f"},
         {"X-Blackboard-product", "Blackboard Learn &#8482; 3400.7.0-rel.5+e229b7f"},
         {"X-Frame-Options", "SAMEORIGIN"},
         {"Content-Length", "62"},
         {"Connection", "keep-alive"}
       ],
       request_url: "https://bd-partner-a-original.blackboard.com/learn/api/public/v1/system/version",
       status_code: 200
     }}

  """

  alias Learn.{RestClient}
  import HTTPoison
  import Poison
  # oauth
  @v1_oauth2_token "/learn/api/public/v1/oauth2/token"                          # Since: 2015.11.0
  @v1_oauth2_authorization_code "/learn/api/public/v1/oauth2/authorizationcode" # Since: 3200.7.0

  @v1_announcements "/learn/api/public/v1/announcements"                        # Since: 3100.7.0

  @v1_courses "/learn/api/public/v1/courses"                                    # Since: 3000.1.0
  @v2_courses "/learn/api/public/v2/courses"                                    # Since: 3400.8.0

  @v1_dataSources "/learn/api/public/v1/dataSources"                            # Since: 3000.1.0

  @v1_users "/learn/api/public/v1/users"                                        # Since: 3000.1.0

  @v1_system_version  "/learn/api/public/v1/system/version"                     # Since: 3000.3.0


  @enforce_keys [:fqdn, :key, :secret]
  defstruct [:fqdn, :key, :secret, :token ]

  @doc """
    new: Create a new RestClient

    Returns %RestClient{fqdn: "fqdn", key: "key", secret: "secret"}

    ## Examples

    iex(1)> rc = Learn.RestClient.new("bd-partner-a-original.blackboard.com", "00000000-1111-2222-3333-444444444444", "12345678901234567890123456789012")
    %Learn.RestClient{
      fqdn: "bd-partner-a-original.blackboard.com",
      key: "00000000-1111-2222-3333-444444444444",
      secret: "12345678901234567890123456789012"
    }

    iex(3)> rc = Learn.RestClient.new("bd-partner-a-original.blackboard.com", System.get_env("APP_KEY"), System.get_env("APP_SECRET"))
%Learn.RestClient{
  token: nil,
  fqdn: "bd-partner-a-original.blackboard.com",
  key: "d128e50d-c91e-47d3-a97e-9d0c8a77fb5d",
  secret: "xyzzy"
}

  """
  def new(fqdn, key, secret) do
    %RestClient{fqdn: fqdn, key: key, secret: secret}
  end

  def new(fqdn, key, secret, token) do
    %RestClient{fqdn: fqdn, key: key, secret: secret, token: token}
  end


  def post_oauth2_token(rest_client, code, redirect_uri) do
    headers = [{"Content-Type",  "application/x-www-form-urlencoded"}]
    options = [hackney: [basic_auth: {"#{rest_client.key}", "#{rest_client.secret}"}] ]
    body =""
    url = ""
    case code do
      0 ->
        url = "https://#{rest_client.fqdn}#{@v1_oauth2_token}"
        body = "grant_type=client_credentials"
      _ ->
        url = "https://#{rest_client.fqdn}#{@v1_oauth2_token}" <> "?code=#{code}&redirect_uri=#{redirect_uri}"
        body = "grant_type=authorization_code"
    end
    # IO.puts :stdio, "Calling HTTPoison.post"
    {code, respone} = HTTPoison.post url, body, headers, options
  end

  @doc """
    Convenience method to get and save the authorization. Returns a RestClient
    with the token. If we call this with code other than 0, we're doing 3LO.
    We've previously gotten the code from logging in via the
    /learn/api/public/v1/oauth2/authorizationcode endpoint.

    Example:
    Put the following in a browser's address field.
    https://bd-partner-a-original.blackboard.com/learn/api/public/v1/oauth2/authorizationcode?redirect_uri=https://localhost&response_type=code&client_id=d128e50d-c91e-47d3-a97e-9d0c8a77fb5d&scope=read%20offline
    Browser is then redirected to Learn login page. We login with mkauffman-student3 and browser is sent to:
    https://localhost/?code=oDNloDmgqEFbPoSRCYjKKskQMBIYjWp6

    iex(4)> rcauth = Learn.RestClient.authorize(rc, "oDNloDmgqEFbPoSRCYjKKskQMBIYjWp6", "https://localhost")
%Learn.RestClient{
  token: %{
    "access_token" => "qm1vVtvjR05Zs405YIvzOwGY2aJQ809f",
    "expires_in" => 3599,
    "scope" => "read",
    "token_type" => "bearer",
    "user_id" => "02f8aa8b159c4bd3a54a35bb29bc1f8c"
  },
  fqdn: "bd-partner-a-original.blackboard.com",
  key: "d128e50d-c91e-47d3-a97e-9d0c8a77fb5d",
  secret: "xyzzy"
}

  """
  def authorize(rest_client, code, redirect_uri) do
    # If you're new to Elixir, like I am, the following looks 'interesting'.
    # Demystified: The case statement takes the results of the post_ and pattern matches them
    # into a code and a response. The code can be :ok, or something else. If it's :ok then
    # we create a token by decoding the response.body. If it's _ (something else) then
    # we raise an exception. Once we have our token we pattern match again. If the token
    # consists of a map that contains "access_token", "token_type", and "expires_in", then
    # we're good and we create & return a new RestClient that also contains the token.
    case {code, response} = post_oauth2_token(rest_client, code, redirect_uri) do
      {:ok, response} -> {:ok, token} = Poison.decode(response.body)
      {_, response } -> raise("rest_client: #{inspect rest_client} code: #{Atom.to_string(code)} response: #{inspect response}")
    end
    case token do
      %{"access_token" => _, "token_type" => _, "expires_in" => _ } -> token
      _ -> raise("rest_client: #{inspect rest_client} token: #{inspect token}")
    end
    # With the return value we can do rest_client.token["access_token"], or .token["expires_in"]
    RestClient.new(rest_client.fqdn, rest_client.key, rest_client.secret, token)
  end

  @doc """
    Convenience method to authorize using two-legged OAuth.
    We call authorize with a code of 0 to indicate two-legged.
    Of course there is no redirect_uri.
  """
  def authorize(rest_client) do
    authorize(rest_client, 0, "")
  end

  ## Functions that call the v1_announcements endpoint
  def get_announcements(rest_client, params \\ %{} ) do
    params = %{offset: 0} |> Map.merge(params) # Default to 1 param, an offset of 0
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_announcements}?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {code, response} = HTTPoison.get url, headers, options
  end

  ## COURSE CONTENTS
  @doc """
    Call the v1_courses endpoint to get it's top-level content items.
  """
  def get_v1_courses_contents(rest_client, courseId, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_courses}/#{courseId}/contents?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {code, response} = HTTPoison.get url, headers, options
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
    {code, response} = HTTPoison.get url, headers, options
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
    {code, response} = HTTPoison.post url, body, headers, options
  end


  ## COURSE MEMBERSHIPS
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
    {code, response} = get_v2_course(rest_client, course_id)
  end

  @doc """
    Call the latest v_ courses endpoint, include a map of the parameters that is turned
    into a parameter list and attached to the URL we make the request to.
  """
  def get_courses(rest_client, params \\ %{}) do
    {code, response} = get_v2_courses(rest_client, params )
  end

  ## Functions that call the @v1_dataSources endpoints
  def get_dataSources(rest_client, params \\ %{}) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_dataSources}?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {code, response} = HTTPoison.get url, headers, options
  end

  ## Functions that call the v1_system_* endpoints
  @doc """
  Get the Learn version information.
  Example use:
   iex(5)> {code, response} = Learn.RestClient.get_system_version(rc)
  """
  def get_system_version(rest_client) do
    # GET /learn/api/public/v1/system/version
    url = "https://#{rest_client.fqdn}#{@v1_system_version}"
    {code, response} = HTTPoison.get url
  end

  ## Functions that call the v1_users endpoint
  def get_user(rest_client, user_id) do
    url = "https://#{rest_client.fqdn}#{@v1_users}/#{user_id}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {code, response} = HTTPoison.get url, headers, options
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





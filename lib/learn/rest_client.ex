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
  # oauth
  @v1_oauth2_token "/learn/api/public/v1/oauth2/token"
  @v1_oauth2_authorization_code "/learn/api/public/v1/oauth2/authorizationcode"

  @v1_system_version  "/learn/api/public/v1/system/version"

  @v1_users "/learn/api/public/v1/users"

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

  #Example use:
  # iex(5)> {code, response} = Learn.RestClient.get_learn_version(rc)

  def get_system_version(rest_client) do
    # GET /learn/api/public/v1/system/version
    url = "https://#{rest_client.fqdn}#{@v1_system_version}"
    {code, response} = HTTPoison.get url
  end

  def post_oauth2_token(rest_client, code, redirect_uri) do
    headers = [{"Content-Type",  "application/x-www-form-urlencoded"}]
    options = [hackney: [basic_auth: {"#{rest_client.key}", "#{rest_client.secret}"}] ]
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

  ## Functions that call the v1_users endpoint
  def get_user(rest_client, user_id) do
    url = "https://#{rest_client.fqdn}#{@v1_users}/#{user_id}"
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

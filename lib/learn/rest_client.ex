defmodule Learn.RestClient do
  require IEx
  @moduledoc """
  Learn.RestClient
  2018.12.18 MBK - A large change here...
  This is no longer an abstraction of Blackboard Learn REST APIs for Elixir.
  It's now only a representation of the client that is used by the APIs.
  The APIs are all in Learn.Api.

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

    iex> Learn.Api.System.get_system_version(rc)
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





  # oauth
  @v1_oauth2_token "/learn/api/public/v1/oauth2/token"                          # Since: 2015.11.0
  @v1_oauth2_authorization_code "/learn/api/public/v1/oauth2/authorizationcode" # Since: 3200.7.0

  @enforce_keys [:fqdn, :key, :secret]
  defstruct [:fqdn, :key, :secret, :token, :auth_time ]

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

  def new(fqdn, key, secret, token, auth_time ) do
    %RestClient{fqdn: fqdn, key: key, secret: secret, token: token, auth_time: auth_time}
  end

  def post_oauth2_token(rest_client, code, redirect_uri) do
    headers = [{"Content-Type",  "application/x-www-form-urlencoded"}]
    options = [hackney: [basic_auth: {"#{rest_client.key}", "#{rest_client.secret}"}] ]

    {url, body} = case code do
      0 ->
        {"https://#{rest_client.fqdn}#{@v1_oauth2_token}",  "grant_type=client_credentials" }
      _ ->
        {"https://#{rest_client.fqdn}#{@v1_oauth2_token}" <> "?code=#{code}&redirect_uri=#{redirect_uri}",  "grant_type=authorization_code"}
    end
    IO.puts :stdio, "Calling HTTPoison.post"

    {status, response} = HTTPoison.post url, body, headers, options
    {status, response}
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

    {status, response} = post_oauth2_token(rest_client, code, redirect_uri)

    {:ok, token} =
    case {status, response} do
        {:ok, response} ->  Poison.decode(response.body)
        {_, response } -> raise("rest_client: #{inspect rest_client} status: #{Atom.to_string(status)} response: #{inspect response}")
    end

    case token do
      %{"access_token" => _, "token_type" => _, "expires_in" => _ } -> token
      _ -> raise("rest_client: #{inspect rest_client} token: #{inspect token}")
    end

    auth_time = DateTime.utc_now()
    # With the return value we can do rest_client.token["access_token"], or .token["expires_in"]
    authorized_client = RestClient.new(rest_client.fqdn, rest_client.key, rest_client.secret, token, auth_time )
    authorized_client
  end

  @doc """
    Convenience method to authorize using two-legged OAuth.
    We call authorize with a code of 0 to indicate two-legged.
    Of course there is no redirect_uri.

        self.expires_in = self.auth['expires_in']
        m, s = divmod(self.expires_in, 60)
        self.now = datetime.datetime.now()
        self.expires_at = self.now + datetime.timedelta(seconds=s, minutes=m)

  """
  def authorize(rest_client) do
    authorize(rest_client, 0, "")
  end

  @doc """
    Method to take in any /learn enpoint and GET the response.
  """
  def get_endpoint(rest_client, url_path, params \\ %{} ) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{url_path}?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {status, response} = HTTPoison.get url, headers, options
    {status, response}
  end

  @doc """
        Method to POST to any /learn enpoint.
        map_of_bodyvals example: x = %{"courseId" => "mbK_514_1"}
  """
  def post_endpoint(rest_client, url_path, map_of_bodyvals, params \\ %{} ) do
    params = %{offset: 0} |> Map.merge(params)
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{url_path}?#{paramlist}"
    body = Poison.encode!(map_of_bodyvals)
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {status, response} = HTTPoison.post url, body, headers, options
    {status, response}
  end
end





defmodule Learn.Api.Announcements do
  require IEx
  @moduledoc """
  Learn.Api.Announcements

  """

  @v1_announcements "/learn/api/public/v1/announcements"                        # Since: 3100.7.0

   ## ANNOUNCEMENTS
  ## Functions that call the v1_announcements endpoint
  def get_announcements(rest_client, params \\ %{} ) do
    params = %{offset: 0} |> Map.merge(params) # Default to 1 param, an offset of 0
    paramlist = URI.encode_query(params) # Turn the map into a parameter list string in one fell swoop.
    url = "https://#{rest_client.fqdn}#{@v1_announcements}?#{paramlist}"
    headers = [{"Content-Type",  "application/json"}, {"Authorization", "Bearer #{rest_client.token["access_token"]}"}]
    options = []
    {status, response} = HTTPoison.get url, headers, options
    {status, response}  # necessary for documenting the return objects w/o a warning on the prior line.
  end

end

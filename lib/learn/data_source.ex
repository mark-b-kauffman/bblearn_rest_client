defmodule Learn.DataSource do

  defstruct [:id, :externalId, :description]

  @doc """
  Create a new DataSource from the JSON that comes back from GET v1/dataSources/{dataSourceId}

  iex> {code, response} = RestClient.get(rcauth, "/learn/api/public/v1/dataSources/_2_1")
  iex> data_source = Learn.DataSource.new_from_json(response.body)
  %Learn.DataSource{
    description: "System data source used for associating records that are created via web browser.",
    externalId: "SYSTEM",
    id: "_2_1"
  }

  iex(2)> my_dsk = %Learn.DataSource{externalId: "TESTDSK", description: "This is the TESTDSK"}
  %Learn.DataSource{
    description: "This is the TESTDSK",
    externalId: "TESTDSK",
    id: nil
  }

  iex(11)> json = Poison.encode!(my_dsk)
  "{\"id\":null,\"externalId\":\"TESTDSK\",\"description\":\"This is the TESTDSK\"}"

  """
  def new_from_json(json) do # returns a DataSource
    my_map = Poison.decode!(json)
    data_source = Learn.RestUtil.to_struct(Learn.DataSource, my_map)
    data_source
  end

end #Learn.DataSource

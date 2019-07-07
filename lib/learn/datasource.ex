defmodule Learn.Datasource do

  defstruct [:id, :externalId, :description]

  @doc """
  Create a new Datasource from the JSON that comes back from GET v1/dataSources/{dataSourceId}

  iex> {code, response} = RestClient.get(rcauth, "/learn/api/public/v1/dataSources/_2_1")
  iex> data_source = Learn.Datasource.new_from_json(response.body)
  %Learn.Datasource{
    description: "System data source used for associating records that are created via web browser.",
    externalId: "SYSTEM",
    id: "_2_1"
  }

  iex(2)> my_dsk = %Learn.Datasource{externalId: "TESTDSK", description: "This is the TESTDSK"}
  %Learn.Datasource{
    description: "This is the TESTDSK",
    externalId: "TESTDSK",
    id: nil
  }

  iex(11)> json = Poison.encode!(my_dsk)
  "{\"id\":null,\"externalId\":\"TESTDSK\",\"description\":\"This is the TESTDSK\"}"

  """
  def new_from_json(json) do # returns a Datasource
    my_map = Poison.decode!(json)
    data_source = Learn.RestUtil.to_struct(Learn.Datasource, my_map)
    data_source
  end

end #Learn.Datasource

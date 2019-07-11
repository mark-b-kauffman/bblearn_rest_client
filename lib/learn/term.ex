defmodule Learn.Term do

  defstruct [:id, :externalId, :dataSourceId, :name, :description, :availability ]

  @doc """
  Create a new Term from the JSON that comes back from GET v1/terms/{termId}
  Example Value:
  {
    "id": "string",
    "externalId": "string",
    "dataSourceId": "string",
    "name": "string",
    "description": "<!-- {\"bbMLEditorVersion\":1} --><div data-bbid=\"bbml-editor-id_9c6a9556-80a5-496c-b10d-af2a9ab22d45\"> <h4>Header Large</h4>  <h5>Header Medium</h5>  <h6>Header Small</h6>  <p><strong>Bold&nbsp;</strong><em>Italic&nbsp;<span style=\"text-decoration: underline;\">Italic Underline</span></em></p> <ul>   <li><span style=\"text-decoration: underline;\"><em></em></span>Bullet 1</li>  <li>Bullet 2</li> </ul> <p>  <img src=\"@X@EmbeddedFile.requestUrlStub@X@bbcswebdav/xid-1217_1\">   <span>\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\"</span> </p>  <p><span>&lt;braces test=\"values\" other=\"strange things\"&gt;</span></p> <p>Header Small</p> <ol>   <li>Number 1</li>   <li>Number 2</li> </ol>  <p>Just words followed by a formula</p>  <p><img align=\"middle\" alt=\"3 divided by 4 2 root of 7\" class=\"Wirisformula\" src=\"@X@EmbeddedFile.requestUrlStub@X@sessions/EA5F7FF3DF32D271D0E54AF0150D924A/anonymous/wiris/49728c9f5b4091622e2f4d183d857d35.png\" data-mathml=\"«math xmlns=¨http://www.w3.org/1998/Math/MathML¨»«mn»3«/mn»«mo»/«/mo»«mn»4«/mn»«mroot»«mn»7«/mn»«mn»2«/mn»«/mroot»«/math»\"></p> <p><a href=\"http://www.blackboard.com\">Blackboard</a></p> </div>",
    "availability": {
      "available": "Yes",
      "duration": {
        "type": "Continuous",
        "start": "2019-07-08T23:41:26.065Z",
        "end": "2019-07-08T23:41:26.065Z",
        "daysOfUse": 0
      }
    }
  }

  iex(7)> {status, response} = Api.Terms.get_term(rcauth, "_2_1")
  {:ok,
  %HTTPoison.Response{
    body: "{\"id\":\"_2_1\",\"externalId\":\"9f6c61bf1e2d4ed3baf60afc7ea19708\",\"dataSourceId\":\"_2_1\",\"name\":\"July 2019 Term\",\"description\":\"<p>The July 2019&nbsp;Term.&nbsp; Runs to Jan 1&nbsp;2020.</p>\",\"availability\":{\"available\":\"Yes\",\"duration\":{\"type\":\"DateRange\",\"start\":\"2019-07-11T00:00:00.000Z\",\"end\":\"2020-01-01T23:59:59.000Z\"}}}",

    iex(11)> myterm = Learn.Term.new_from_json(response.body)
    %Learn.Term{
      availability: %{
        "available" => "Yes",
        "duration" => %{
          "end" => "2020-01-01T23:59:59.000Z",
          "start" => "2019-07-11T00:00:00.000Z",
          "type" => "DateRange"
        }
      },
      dataSourceId: "_2_1",
      description: "<p>The July 2019&nbsp;Term.&nbsp; Runs to Jan 1&nbsp;2020.</p>",
      externalId: "9f6c61bf1e2d4ed3baf60afc7ea19708",
      id: "_2_1",
      name: "July 2019 Term"
    }

  """
  def new_from_json(json) do # returns a Term
    my_map = Poison.decode!(json)
    term = Learn.RestUtil.to_struct(Learn.Term, my_map)
    term
  end

end #Learn.Term

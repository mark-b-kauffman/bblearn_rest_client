defmodule Learn.Course do
  alias Learn.{Course}
  import Poison

  defstruct [:json, :map ]

  def new_from_json(json) do
    my_map = Poison.decode!(json)
    %Course{json: json, map: my_map}
  end

  @doc """
      v2 POST
      {
        "externalId": "string",
        "dataSourceId": "string",
        "courseId": "string",
        "name": "string",
        "description": "string",
        "organization": true,
        "ultraStatus": "Undecided",
        "allowGuests": true,
        "closedComplete": true,
        "termId": "string",
        "availability": {
          "available": "Yes",
          "duration": {
            "type": "Continuous",
            "start": "2018-08-03T23:24:05.437Z",
            "end": "2018-08-03T23:24:05.437Z",
            "daysOfUse": 0
          }
        },
        "enrollment": {
          "type": "InstructorLed",
          "start": "2018-08-03T23:24:05.437Z",
          "end": "2018-08-03T23:24:05.437Z",
          "accessCode": "string"
        },
        "locale": {
          "id": "string",
          "force": true
        }
      }

  """

end #Learn.Course

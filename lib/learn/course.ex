defmodule Learn.Course do

  defstruct [:allowGuests, :availability, :closedComplete, :courseId, :created,
   :dataSourceId, :enrollment, :externalAccessUrl, :guestAccessUrl, :id,
   :locale, :name, :organization, :readOnly, :ultraStatus, :uuid]

  @doc """
  Create a new Course from the JSON that comes back from GET /courses/course_id

  iex> {code, response} = RestClient.get_course(rcauth, "courseId:1")
  iex> course = Course.new_from_json(response.body)
  %Learn.Course{
    allowGuests: true,
    availability: %{"available" => "Yes", "duration" => %{"type" => "Continuous"}},
    OR: availability: %{"available" => "Yes",
                    "duration" => %{"end" => "2025-08-15T03:59:59.000Z", "start" => "2018-08-13T04:00:00.000Z",
                    "type" => "DateRange"}},
    closedComplete: false,
    courseId: "1",
    created: "2018-02-15T19:50:25.933Z",
    dataSourceId: "_140_1",
    enrollment: %{"type" => "InstructorLed"},
    externalAccessUrl: "https://bd-partner-a-original.blackboard.com/webapps/blackboard/execute/courseMain?course_id=_29_1&sc=",
    guestAccessUrl: "https://bd-partner-a-original.blackboard.com/webapps/blackboard/execute/courseMain?course_id=_29_1&sc=",
    id: "_29_1",
    locale: %{"force" => false},
    name: "Demo Course For Testing Purpose - NBC",
    organization: false,
    readOnly: nil,
    ultraStatus: "Classic",
    uuid: "250dfb5f3cc3428eb84dc8d7cd11ea87"
  }

  iex(2)> my_course = %Learn.Course{allowGuests: true, availability: %{"available" => "Yes", "duration" => %{"type" => "Continuous"}}, courseId: "mbk-test1", dataSourceId: "externalId:SYSTEM", enrollment: %{"type" => "InstructorLed"}, name: "Demo Course For Testing Purpose - mbk-test1", ultraStatus: "Classic"}
  %Learn.Course{
      allowGuests: true,
      availability: %{"available" => "Yes", "duration" => %{"type" => "Continuous"}},
      closedComplete: nil,
      courseId: "mbk-test1",
      created: nil,
      dataSourceId: "externalId:SYSTEM",
      enrollment: %{"type" => "InstructorLed"},
      externalAccessUrl: nil,
      guestAccessUrl: nil,
      id: nil,
      locale: nil,
      name: "Demo Course For Testing Purpose - mbk-test1",
      organization: nil,
      readOnly: nil,
      ultraStatus: "Classic",
      uuid: nil
    }

  iex(4)> { status, json }  = Poison.encode(my_course)
  {:ok,
    "{\"uuid\":null,\"ultraStatus\":\"Classic\",\"readOnly\":null,\"organization\":null,\"name\":\"Demo Course For Testing Purpose - mbk-test1\",\"locale\":null,\"id\":null,\"guestAccessUrl\":null,\"externalAccessUrl\":null,\"enrollment\":{\"type\":\"InstructorLed\"},\"dataSourceId\":\"externalId:SYSTEM\",\"created\":null,\"courseId\":\"mbk-test1\",\"closedComplete\":null,\"availability\":{\"duration\":{\"type\":\"Continuous\"},\"available\":\"Yes\"},\"allowGuests\":true}"}

  """
  def new_from_json(json) do # returns a Course
    my_map = Poison.decode!(json)
    course = Learn.RestUtil.to_struct(Learn.Course, my_map)
    course
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

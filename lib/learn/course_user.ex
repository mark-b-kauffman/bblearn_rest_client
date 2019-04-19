defmodule Learn.CourseUser do

  # Struct for a v1 CourseUser
  defstruct [:userId, :courseId, :childCourse, :dataSourceId, :availability, :courseRoleId, :user, :course]

  @doc """
  {
    "userId": "string",
    "courseId": "string",
    "childCourseId": "string",
    "dataSourceId": "string",
    "created": "2019-04-18T21:02:44.928Z",
    "availability": {
      "available": "Yes"
    },
    "courseRoleId": "Instructor",
    "bypassCourseAvailabilityUntil": "2019-04-18T21:02:44.928Z",
    "lastAccessed": "2019-04-18T21:02:44.928Z",
    "user": {
      "id": "string",
      "uuid": "string",
      "externalId": "string",
      "dataSourceId": "string",
      "userName": "string",
      "studentId": "string",
      "educationLevel": "K8",
      "gender": "Female",
      "birthDate": "2019-04-18T21:02:44.928Z",
      "created": "2019-04-18T21:02:44.928Z",
      "lastLogin": "2019-04-18T21:02:44.928Z",
        "institutionRoleIds": [
          "string"
        ],
        "systemRoleIds": [
          "SystemAdmin"
        ],
        "availability": {
          "available": "Yes"
        },
        "name": {
          "given": "string",
          "family": "string",
          "middle": "string",
          "other": "string",
          "suffix": "string",
          "title": "string"
        },
        "job": {
          "title": "string",
          "department": "string",
          "company": "string"
        },
        "contact": {
          "homePhone": "string",
          "mobilePhone": "string",
          "businessPhone": "string",
          "businessFax": "string",
          "email": "string",
          "webPage": "string"
        },
        "address": {
          "street1": "string",
          "street2": "string",
          "city": "string",
          "state": "string",
          "zipCode": "string",
          "country": "string"
        },
        "locale": {
          "id": "string",
          "calendar": "Gregorian",
          "firstDayOfWeek": "Sunday"
        }
    },
    "course": {
      "id": "string",
      "uuid": "string",
      "externalId": "string",
      "dataSourceId": "string",
      "courseId": "string",
      "name": "string",
      "description": "string",
      "created": "2019-04-18T21:02:44.928Z",
      "organization": true,
      "ultraStatus": "Undecided",
      "allowGuests": true,
      "readOnly": true,
      "termId": "string",
      "availability": {
        "available": "Yes",
        "duration": {
          "type": "Continuous",
          "start": "2019-04-18T21:02:44.929Z",
          "end": "2019-04-18T21:02:44.929Z",
          "daysOfUse": 0
        }
      },
      "enrollment": {
        "type": "InstructorLed",
        "start": "2019-04-18T21:02:44.929Z",
        "end": "2019-04-18T21:02:44.929Z",
        "accessCode": "string"
      },
      "locale": {
        "id": "string",
        "force": true
      },
      "hasChildren": true,
      "parentId": "string",
      "externalAccessUrl": "string",
      "guestAccessUrl": "string"
    }
  }
  Create a new CourseUser from the JSON that comes back from GET /courses/user_id

  iex> {code, response} = Api.Users.get_user(rcauth, "userName:mkauffman")
  iex(12)> user_resp.body
  "{\"id\":\"_5_1\",\"uuid\":\"00d1ad66e50e45238e1efda0400f6ec1\",\"externalId\":\"mkauffman\",\"dataSourceId\":\"_2_1\",\"userName\":\"mkauffman\",\"studentId\":\"mkauffman\",\"educationLevel\":\"Unknown\",\"gender\":\"Unknown\",\"created\":\"2019-03-28T19:33:55.549Z\",\"lastLogin\":\"2019-04-14T03:21:57.338Z\",\"institutionRoleIds\":[\"STUDENT\"],\"systemRoleIds\":[\"SystemAdmin\"],\"availability\":{\"available\":\"Yes\"},\"name\":{\"given\":\"Mark\",\"family\":\"Kauffman\"},\"contact\":{\"email\":\"mark.kauffman@blackboard.com\"}}"
  iex(13)> my_user = User.new_from_json(user_resp.body)
  %Learn.User{
    address: nil,
    availability: %{"available" => "Yes"},
    birthDate: nil,
    contact: %{"email" => "mark.kauffman@blackboard.com"},
    dataSourceId: "_2_1",
    educationLevel: "Unknown",
    externalId: "mkauffman",
    gender: "Unknown",
    id: "_5_1",
    institutionRoleIds: ["STUDENT"],
    job: nil,
    locale: nil,
    name: %{"family" => "Kauffman", "given" => "Mark"},
    studentId: "mkauffman",
    systemRoleIds: ["SystemAdmin"],
    userName: "mkauffman",
    uuid: "00d1ad66e50e45238e1efda0400f6ec1"
  }

  iex(14)> my_user_new = %Learn.User{address: nil, availability: %{"available" => "Yes"}, userName: "mkauffman-new1", password: "N0n10furb1z",
  ...(14)> dataSourceId: "externalId:SYSTEM", gender: "male", name: %{"family" => "KauffmanNew1", "given" => "Mark"},\
  ...(14)> externalId: "mkauffmannew1", institutionRoleIds:  ["FACULTY"], studentId: "mkauffman" }
  %Learn.User{
    address: nil,
    availability: %{"available" => "Yes"},
    birthDate: nil,
    contact: nil,
    dataSourceId: "externalId:SYSTEM",
    educationLevel: nil,
    externalId: "mkauffmannew1",
    gender: "male",
    id: nil,
    institutionRoleIds: ["FACULTY"],
    job: nil,
    locale: nil,
    name: %{"family" => "KauffmanNew1", "given" => "Mark"},
    password: "Ja!S0NdjfmamJ",
    studentId: "mkauffman",
    systemRoleIds: nil,
    userName: "mkauffman-new1",
    uuid: nil
  }

  iex(15)> {code, response} = Api.Users.post_v1_user(rcauth, my_user_new)
    {:ok,
    %HTTPoison.Response{
      body: "{\"id\":\"_6_1\",\"uuid\":\"4c59b447c2704141b592d37ccf824ee0\",\"externalId\":\"mkauffmannew1\",\"dataSourceId\":\"_2_1\",\"userName\":\"mkauffman-new1\",\"studentId\":\"mkauffman\",\"educationLevel\":\"Unknown\",\"gender\":\"Male\",\"created\":\"2019-04-17T23:58:04.285Z\",\"institutionRoleIds\":[\"FACULTY\"],\"systemRoleIds\":[\"User\"],\"availability\":{\"available\":\"Yes\"},\"name\":{\"given\":\"Mark\",\"family\":\"KauffmanNew1\"}}",
      headers: [
        {"Server", "openresty/1.11.2.2"},
        {"Date", "Wed, 17 Apr 2019 23:58:04 GMT"},
        {"Content-Type", "application/json;charset=UTF-8"},

  """
  def new_from_json(json) do # returns a CourseUser
    my_map = Poison.decode!(json)
    user = Learn.RestUtil.to_struct(Learn.CourseUser, my_map)
    user
  end


end #Learn.CourseUser

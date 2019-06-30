defmodule Learn.User do

  # Struct for a v1 User
  defstruct [:id, :uuid, :externalId, :dataSourceId, :userName, :created, :modified, :lastLogin,
   :studentId, :password, :educationLevel, :gender, :birthDate, :institutionRoleIds,
  :systemRoleIds, :availability, :name, :job, :contact, :address, :locale]

  @doc """

    {
    "id": "string",
    "uuid": "string",
    "externalId": "string",
    "dataSourceId": "string",
    "userName": "string",
    "studentId": "string",
    "educationLevel": "K8",
    "gender": "Female",
    "birthDate": "2019-04-17T17:18:03.217Z",
    "created": "2019-04-17T17:18:03.217Z",
    "lastLogin": "2019-04-17T17:18:03.217Z",
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
  }
  Create a new User from the JSON that comes back from GET /courses/user_id

  iex(19)> {status, response} = Api.Users.get_user(rcauth, "userName:shurrey")
  iex(21)> response.body
  "{\"id\":\"_9_1\",\"uuid\":\"a8b3c196ea5647d9a83c1552a882be29\",\"externalId\":\"shurrey\",\"dataSourceId\":\"_2_1\",\"userName\":\"shurrey\",\"studentId\":\"shurrey\",\"educationLevel\":\"Unknown\",\"gender\":\"Unknown\",\"created\":\"2019-06-20T20:34:00.230Z\",\"modified\":\"2019-06-23T23:22:04.936Z\",\"lastLogin\":\"2019-06-23T23:22:04.935Z\",\"institutionRoleIds\":[\"STUDENT\"],\"systemRoleIds\":[\"User\"],\"availability\":{\"available\":\"Yes\"},\"name\":{\"given\":\"Scott\",\"family\":\"Hurrey\"},\"contact\":{\"email\":\"shurrey@smoemail.com\"}}"
    iex(22)> user = Learn.User.new_from_json(response.body)
  %Learn.User{
    address: nil,
    availability: %{"available" => "Yes"},
    birthDate: nil,
    contact: %{"email" => "shurrey@smoemail.com"},
    created: "2019-06-20T20:34:00.230Z",
    dataSourceId: "_2_1",
    educationLevel: "Unknown",
    externalId: "shurrey",
    gender: "Unknown",
    id: "_9_1",
    institutionRoleIds: ["STUDENT"],
    job: nil,
    lastLogin: "2019-06-23T23:22:04.935Z",
    locale: nil,
    modified: "2019-06-23T23:22:04.936Z",
    name: %{"family" => "Hurrey", "given" => "Scott"},
    password: nil,
    studentId: "shurrey",
    systemRoleIds: ["User"],
    userName: "shurrey",
    uuid: "a8b3c196ea5647d9a83c1552a882be29"
  }

  The following creates a new user from the current user with the necessary fields set nil.
  Takes an existing map, user, modifies certain fields to create a new map, buser.
  iex(23)> buser = %{user | created: nil, modified: nil, uuid: nil, contact: %{"email" => "blurry@smoemail.com"}, externalId: "blurry", id: nil, lastLogin: nil, name: %{"family" => "Lurry", "given" => "Brenda"}, studentId: "blurry", userName: "blurry", password: "xyzzy!"}

  The following createsa a new user from scratch.
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

  iex(15)> {status, response} = Api.Users.post_v1_user(rcauth, my_user_new)
    {:ok,
    %HTTPoison.Response{
      body: "{\"id\":\"_6_1\",\"uuid\":\"4c59b447c2704141b592d37ccf824ee0\",\"externalId\":\"mkauffmannew1\",\"dataSourceId\":\"_2_1\",\"userName\":\"mkauffman-new1\",\"studentId\":\"mkauffman\",\"educationLevel\":\"Unknown\",\"gender\":\"Male\",\"created\":\"2019-04-17T23:58:04.285Z\",\"institutionRoleIds\":[\"FACULTY\"],\"systemRoleIds\":[\"User\"],\"availability\":{\"available\":\"Yes\"},\"name\":{\"given\":\"Mark\",\"family\":\"KauffmanNew1\"}}",
      headers: [
        {"Server", "openresty/1.11.2.2"},
        {"Date", "Wed, 17 Apr 2019 23:58:04 GMT"},
        {"Content-Type", "application/json;charset=UTF-8"},

  """
  def new_from_json(json) do # returns a Course
    my_map = Poison.decode!(json)
    user = Learn.RestUtil.to_struct(Learn.User, my_map)
    user
  end


end #Learn.User

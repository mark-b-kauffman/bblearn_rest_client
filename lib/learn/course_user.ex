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

  """
  def new_from_json(json) do # returns a CourseUser
    my_map = Poison.decode!(json)
    user = Learn.RestUtil.to_struct(Learn.CourseUser, my_map)
    user
  end


end #Learn.CourseUser

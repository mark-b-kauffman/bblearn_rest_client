defmodule Learn.LtiPlacement do
  alias Learn.{LtiPlacement}
  import Poison

  defstruct [:id, :name, :description, :iconUrl, :handle,
   :type, :url, :authorId, :instructorCreated, :allowStudents,
   :availability, :launchInNewWindow, :launchLink, :customParameters]

  @doc """
  Create a new LTI Placement from the JSON that comes back from GET /courses/course_id

  """
  def new_from_json(json) do
    my_map = Poison.decode!(json)
    lti_placement = Learn.RestUtil.to_struct(Learn.LtiPlacement, my_map)
  end

end #Learn.LtiPlacement

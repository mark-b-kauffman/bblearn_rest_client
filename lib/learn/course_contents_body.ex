defmodule Learn.CourseContentsBody do
  alias Learn.{CourseContentsBody}
  import Poison

  # JSON: availability\":{\"available\":\"Yes\",\"allowGuests\":true,\"adaptiveRelease\":{}}
  defstruct [:parentId, :title, :body, :description, :position, :availability, :contentHandler]

  def new_blti_link(parentId, title, url) do
    my_avail = Learn.Availability.new()
    my_handler = %{id: "resource/x-bb-blti-link", url: url }
    %CourseContentsBody{parentId: parentId, title: "newcontent", availability: my_avail, contentHandler: my_handler }
  end


  @doc """
    Convenience method for quick creation of content
  """
  def new_blti_link(parentId) do
    new_blti_link(parentId, "newcontent","https://localhost:3000/lti")


  end

end #Learn.CourseContentsBody

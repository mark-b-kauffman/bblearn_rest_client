defmodule Learn.Availability do
  alias Learn.{Availability}
  import Poison

  # JSON: availability\":{\"available\":\"Yes\",\"allowGuests\":true,\"adaptiveRelease\":{}}
  defstruct [:available, :allowGuests, :adaptiveRelease]

  def new() do
    %Availability{available: "Yes", allowGuests: "true", adaptiveRelease: %{} }
  end

end #Learn.Availability

defmodule BblearnRestClientTest do
  use ExUnit.Case
  doctest BblearnRestClient

  test "greets the world" do
    assert BblearnRestClient.hello() == :world
  end
end

defmodule OpenapiClientTest do
  use ExUnit.Case
  doctest OpenapiClient

  test "greets the world" do
    assert OpenapiClient.hello() == :world
  end
end

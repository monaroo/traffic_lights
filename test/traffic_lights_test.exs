defmodule TrafficLightsTest do
  use ExUnit.Case
  doctest TrafficLights

  # TrafficLights.Light ----------------------------------
  test "TrafficLights.Light.start_link/1 init state is green" do
    {:ok, pid} = TrafficLights.Light.start_link([])
    assert :sys.get_state(pid) == :green
  end

  test "current_light/1 functionality" do
    {:ok, pid} = TrafficLights.Light.start_link([])
    assert TrafficLights.Light.current_light(pid) == :green
  end

  test "transition/1 functionality" do
    {:ok, pid} = TrafficLights.Light.start_link([])
    TrafficLights.Light.transition(pid)
    assert :sys.get_state(pid) == :yellow
    TrafficLights.Light.transition(pid)
    TrafficLights.Light.transition(pid)
    assert :sys.get_state(pid) == :green
  end

  # TrafficLights.Grid -------------------------------------
  test "initialize" do
    {:ok, pid} = TrafficLights.Grid.start_link([])

    assert TrafficLights.Grid.current_grid(pid) == [:green, :green, :green, :green, :green]
  end

  test "change 1 light" do
    {:ok, pid} = TrafficLights.Grid.start_link([])
    TrafficLights.Grid.transition(pid)
    assert TrafficLights.Grid.current_grid(pid) == [:yellow, :green, :green, :green, :green]
  end

  test "change multiple lights" do
    {:ok, pid} = TrafficLights.Grid.start_link([])
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    assert TrafficLights.Grid.current_grid(pid) == [:yellow, :yellow, :yellow, :yellow, :yellow]

    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    assert TrafficLights.Grid.current_grid(pid) == [:red, :red, :red, :red, :red]
  end

  test "wrap around" do
    {:ok, pid} = TrafficLights.Grid.start_link([])
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)

    assert TrafficLights.Grid.current_grid(pid) == [:green, :red, :red, :red, :red]

  end
end

defmodule TrafficLights do
  defmodule Light do
    use GenServer
    def change_color(state) do
      case state do
        :green -> :yellow
        :yellow -> :red
        :red -> :green
      end
    end

    @impl true
    def init(_opts) do
      {:ok, :green}
    end

    def start_link(_init_arg) do
      GenServer.start_link(__MODULE__, :green)
    end

    def current_light(pid) do
      GenServer.call(pid, :current_light)
    end

    def transition(pid) do
      GenServer.cast(pid, :transition)
    end

    @impl true
    def handle_call(:current_light, _from, state) do
      {:reply, state, state}
    end

    @impl true
    def handle_cast(:transition, state) do
      new_state = change_color(state)
      {:noreply, new_state}
    end

  end

defmodule Grid do
  use GenServer
  alias TrafficLights.Light

  def start_link(_init_arg) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_opts) do
    pids = Enum.map(1..5, fn _ ->
    {:ok, pid} = Light.start_link([])
    pid
    end)
    {:ok, %{light_grid: pids, transition_index: 0}}
  end

  def transition(light_grid) do
    GenServer.cast(light_grid, :transition)
  end

  def current_grid(light_grid) do
    GenServer.call(light_grid, :current_grid)
  end

  def handle_cast(:transition, state) do

    changing_light = Enum.at(state.light_grid, state.transition_index)
    Light.transition(changing_light)

    # grid = Enum.map(state.light_grid, &Light.current_light/1)
    next_transition_index = rem(state.transition_index + 1, length(state.light_grid))

    new_state = %{state | transition_index: next_transition_index}
    {:noreply, new_state}
  end

  def handle_call(:current_grid, _from, state) do
    grid = Enum.map(state.light_grid, &Light.current_light/1)

    {:reply, grid, state}
  end
end


end

defmodule StreamingPlayground do
  @moduledoc """
  Documentation for `StreamingPlayground`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> StreamingPlayground.hello()
      :world

  """
  def hello do
    :world
  end
end

defmodule MyConsumer do
  use GenStage
  require Logger

  def start_link(_args) do
    initial_state = %{producers: 0, consumers: 0}
    GenStage.start_link(__MODULE__, initial_state)
  end

  def init(initial_state) do
    Logger.info("PageConsumer init #{inspect(self)}")
    {:producer_consumer, initial_state, subscribe_to: []}
  end

  def handle_events(events, _from, state) do
    Logger.info("PageConsumer received #{inspect(events)}")

    Enum.each(events, fn page ->
      IO.inspect(page, label: inspect(self()))
    end)

    IO.inspect(length(events), label: "Events")

    {:noreply, events, state}
  end

  def handle_subscribe(:producer, _opts, from, state) do
    {:automatic, %{state | producers: state.producers + 1}}
    |> IO.inspect(label: "handle_subscribe/producer #{inspect(from)}")
  end

  def handle_subscribe(:consumer, _opts, from, state) do
    {:automatic, %{state | consumers: state.consumers + 1}}
    |> IO.inspect(label: "handle_subscribe/consumer, #{inspect(from)}")
  end

  def handle_cancel(reason, from, %{producers: producers} = state) do
    new_state = %{state | producers: producers - 1}

    # if new_state.producers == 0 do
    #   GenStage.async_info(self(), :terminate)
    # end

    {:noreply, [], new_state} |> IO.inspect(label: "handle_cancel: #{inspect(from)}")
  end

  def handle_info(:terminate, state) do
    {:stop, :shutdown, state} |> IO.inspect(label: "terminate")
  end
end

defmodule MyListTest do
  use ExUnit.Case

  test "enm" do
    Enum.each(MyList.new(), fn e -> IO.inspect(e) end)
  end

  test "resource" do
    start_fun = fn -> [1, 2, 3] end

    next_fun = fn
      [h | t] ->
        if h == 2 do
          {[], t}
        else
          {[h], t}
        end

      [] ->
        {:halt, []}
    end

    after_fun = fn _ -> :ok end

    Stream.resource(start_fun, next_fun, after_fun).({:cont, []}, fn x, a ->
      IO.inspect(a)
      IO.inspect(x)

      {:cont, a}
    end)

    # Stream.resource(start_fun, next_fun, after_fun)
    # |> Stream.each(&IO.inspect/1)
    # |> Stream.each(&IO.inspect/1)
    # |> Stream.run()
  end

  @tag :wip
  test "into stages" do
    {:ok, pid1} = MyConsumer.start_link([])
    {:ok, pid2} = MyConsumer.start_link([])

    hash = fn event ->
      # you can use the event to decide which partition # to assign it to, or use `:none` to ignore it.
      if event > 10 do
        {event, :high}
      else
        {event, :low}
      end
    end

    {:ok, _pid} =
      1..20
      |> Flow.from_enumerable()
      |> Flow.into_stages([{pid1, partition: :high}, {pid2, partition: :low}],
        dispatcher: {GenStage.PartitionDispatcher, [partitions: [:high, :low], hash: hash]}
      )

    {:ok, _pid} =
      Flow.from_stages([pid2])
      |> Flow.map(&IO.inspect(&1, label: :flow_low))
      |> Flow.start_link()

    {:ok, _pid} =
      Flow.from_stages([pid1])
      |> Flow.map(&IO.inspect(&1, label: :flow_high))
      |> Flow.start_link()

    Process.sleep(10000)
  end
end

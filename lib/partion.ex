defmodule Partion do
  defstruct [:stream, :left, :right, :filter, :fun]

  def new(stream, filter, fun) do
    %__MODULE__{stream: stream, left: nil, right: nil, filter: filter, fun: fun}
  end

  defimpl Enumerable do
    @impl true
    def count(_struct) do
      {:error, __MODULE__}
    end

    @impl true
    def member?(_struct, _element) do
      {:error, __MODULE__}
    end

    @impl true
    def reduce(struct, acc, fun)

    def reduce(struct, {:cont, nil}, _fun) do
      reduce(struct, {:cont, struct}, _fun)
    end

    def reduce(struct, {:cont, acc}, fun) do
      Stream.resource(
        fn -> [] end,
        fn _ -> 1 end,
        fn _ -> :ok end
      ).(acc, fun)
    end

    def reduce(_struct, {:halt, acc}, _fun) do
      {:halted, acc}
    end

    def reduce(struct, {:suspend, acc}, fun) do
      {:suspended, acc, &reduce(struct, &1, fun)}
    end

    @impl true
    def slice(_array) do
      {:error, __MODULE__}
    end
  end
end

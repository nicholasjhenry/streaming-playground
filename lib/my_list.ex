defmodule MyList do
  defstruct [:data]

  def new() do
    %__MODULE__{data: [1, 2, 3]}
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

    def reduce(struct, {:cont, acc}, fun) do
      case struct.data do
        [h | t] ->
          reduce(%{struct | data: t}, fun.(h, acc), fun)

        [] ->
          {:ok, acc}
      end
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

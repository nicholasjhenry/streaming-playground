defmodule MyCollectable do
  defstruct [:foo]

  def new do
    %__MODULE__{}
  end

  defimpl Collectable do
    def into(initial_value) do
      collector_fun = fn
        _acc, {:cont, elem} ->
          IO.inspect(elem, label: "coll >>>")

        acc, :done ->
          acc

        _acc, :halt ->
          :ok
      end

      initial_acc = initial_value

      {initial_acc, collector_fun}
    end
  end
end

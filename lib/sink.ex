defmodule Sink do
  defstruct [:builder]

  def map(dest, fun) do
    builder = fn ->
      {state, dest_fun} = Collectable.into(dest)

      collector_fun = fn
        state, {:cont, elem} -> dest_fun.(state, {:cont, fun.(elem)})
        state, :done -> dest_fun.(state, :done)
        state, :halt -> dest_fun.(state, :halt)
      end

      {state, collector_fun}
    end

    %Sink{builder: builder}
  end
end

defimpl Collectable, for: Sink do
  def into(%Sink{builder: builder}) do
    builder.()
  end
end

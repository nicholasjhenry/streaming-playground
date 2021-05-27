defmodule ZStreamTest do
  use ExUnit.Case

  defmodule AnotherStream do
    def foo(stream) do
      Stream.each(stream, &IO.inspect(inspect(&1), label: "foo >>>"))
    end

    def bar(stream) do
      Stream.each(stream, &IO.inspect(inspect(&1), label: "bar >>>"))
    end

    def tee(stream, functions) do
      Enum.each(functions, fn f -> f.(stream) |> Stream.run() end)
    end
  end

  test "something simple" do
    [:foo, 1, 2, :bar, 4, 5]
    |> Stream.each(&IO.inspect/1)
    |> Stream.transform(nil, fn
      :foo, _ -> {[], :foo}
      :bar, _ -> {[], :bar}
      line, tag -> {[{tag, line}], tag}
    end)
    |> Enum.to_list()
    |> IO.inspect()

    # |> AnotherStream.tee([&AnotherStream.foo/1, &AnotherStream.bar/1])
  end

  test "filter" do
    [:foo, 1, 2, :bar, 4, 5]
    |> Stream.transform(nil, fn
      :foo, _ -> {[], :foo}
      :bar, _ -> {[], :bar}
      line, tag -> {[{tag, line}], tag}
    end)
    |> Partion.new(fn _ -> true end, &AnotherStream.foo/1)
    |> AnotherStream.foo()
    |> Stream.run()
  end

  @tag :wip
  test "stream" do
    "test/fixtures/test.zip"
    |> File.stream!([], :line)
    |> Zstream.unzip()
    |> Enum.reduce(%{}, fn
      {:entry, %Zstream.Entry{name: file_name} = _entry}, state ->
        IO.inspect(file_name, label: "filename")
        IO.inspect(state, label: "state")
        state

      {:data, :eof}, state ->
        IO.inspect(state, label: "state")
        state

      {:data, data}, state ->
        IO.inspect(data, label: "data")
        IO.inspect(state, label: "state")
        state
    end)
  end

  test "original example" do
    "test/fixtures/test.zip"
    |> File.stream!([], 512)
    |> Zstream.unzip()
    |> Enum.reduce(%{chunks: 0}, fn
      {:entry, %Zstream.Entry{name: file_name}}, state ->
        IO.puts(file_name)
        state

      {:data, :eof}, state ->
        IO.inspect(state, label: :eof)
        %{chunks: 0}

      {:data, _data}, state ->
        %{chunks: state.chunks + 1}
    end)
  end
end

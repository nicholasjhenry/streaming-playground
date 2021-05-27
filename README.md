# Streaming Playground

A playground for `Stream`.

## Notes

[A primer on Elixir Stream](https://activesphere.com/blog/2017/11/28/stream):

> * The function into emits each element in the *source stream* into the *destination stream*. The function run forces the stream to run.
> * A -> B
> * An implementation is called pull based if B controls the main loop. Whenever B wants more elements it will pull from A.
> * An implementation is called push based if A controls the main loop. A will push the elements to B and B will not have any control over when it will get the next element.
> * Stream.into could be considered as a function that performs the fork transformation.

[File.stream/3](https://hexdocs.pm/elixir/File.html#stream!/3)

* https://github.com/elixir-lang/elixir/blob/v1.12.0/lib/elixir/lib/file.ex#L1659-L1662
* https://github.com/elixir-lang/elixir/blob/v1.12.0/lib/elixir/lib/file/stream.ex

> The stream implements both Enumerable and Collectable protocols, which means it can be used both for read and write.

[Stream.into/3](https://hexdocs.pm/elixir/Stream.html#into/3)

[Collectable](https://hexdocs.pm/elixir/Collectable.html)
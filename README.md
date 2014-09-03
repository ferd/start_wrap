# Dumb Wrapper to make full releases possible in Erlang with a 'main' loop

Because people don't want to wait until they learned what a release is, releases are more complex, and they want to ship something simpler than escripts

This uses a `supervisor_bridge` process to end up supervising any random piece of code you have.

Here are two random programs you can write:

```erlang
-module(hello_world).
-export([main/1]).

main(_) ->
    io:format("Hello, world!~n"),
    0.
```

And

```erlang
-module(hello_parallel_world).
-export([main/1]).

main(Args) ->
    run(proplists:get_value(concurrency, Args)),
    timer:sleep(100),
    0.

run([Val]) ->
    [spawn(fun() -> io:format("Hello, world (~p)!~n", [N]) end)
     || N <- lists:seq(1, list_to_integer(Val))].

```

## How to run code

Build the code you want to run:

```bash
$ erlc *.erl
```

Build the harness:

```bash
$ rebar get-deps compile
```

Run your own code:

```bash
$ erlc *.erl && _rel/start_wrap/bin/start_wrap -pa `pwd` -start_wrap module hello_world
$ erlc *.erl && ./_rel/bin/start_wrap -pa `pwd` -start_wrap module hello_parallel_world -concurrency 5
```

And there you go.

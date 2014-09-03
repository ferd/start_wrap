-module(hello_world).
-export([main/1]).

main(_) ->
    io:format("Hello, world!~n"),
    0.

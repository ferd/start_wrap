-module(hello_parallel_world).
-export([main/1]).

main(Args) ->
    run(proplists:get_value(concurrency, Args)),
    timer:sleep(100),
    0.

run([Val]) ->
    [spawn(fun() -> io:format("Hello, world (~p)!~n", [N]) end)
     || N <- lists:seq(1, list_to_integer(Val))].

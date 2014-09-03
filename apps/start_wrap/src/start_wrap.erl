-module(start_wrap).
-behaviour(application).

-export([start/1, start/2, stop/1]).

start(_) ->
    application:ensure_all_started(?MODULE).

start(_,_) ->
    start_wrap_sup:start_link().

stop(_) -> ok.

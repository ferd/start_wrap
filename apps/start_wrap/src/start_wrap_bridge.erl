-module(start_wrap_bridge).
-behaviour(supervisor_bridge).

-export([start_link/3]).
-export([init/1, terminate/2]).

start_link(M,F,Args) ->
    supervisor_bridge:start_link(?MODULE, {M,F,Args}).

init({M,F,A}) ->
    Pid = proc_lib:spawn_link(wrap(M,F,A)),
    {ok, Pid, Pid}.

wrap(M,F,A) ->
    fun() ->
        try erlang:apply(M,F,A) of
            0 -> halt(0);
            N when is_integer(N) -> halt(N);
            _ -> halt(1)
        catch
            Class:Reason ->
                io:format(standard_error,
                          "~p:~p/~p called with arguments ~p "
                          "terminated with a ~p for reason ~p~n",
                          [M,F,length(A),A, Class, Reason]),
                halt(1)
        end
    end.

terminate(shutdown, Pid) ->
    shutdown(Pid, shutdown);
terminate(Reason, Pid) ->
    io:format(standard_error,
              "Program interrupted by the Erlang virtual machine "
              "for reason: ~p~n",
              [Reason]),
    shutdown(Pid, Reason).

shutdown(Pid, Reason) ->
    unlink(Pid),
    exit(Pid, Reason).

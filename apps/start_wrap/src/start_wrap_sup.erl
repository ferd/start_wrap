-module(start_wrap_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, start_wrap}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

init([]) ->
    Mod = get_module(),
    Fun = main,
    Args = [init:get_arguments()],
    {ok, {{one_for_one, 5, 10}, [
        {bridge,
         {start_wrap_bridge, start_link, [Mod,Fun,Args]},
         permanent, 5000, supervisor, [start_wrap_bridge]}
    ]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
get_module() ->
    case application:get_env(start_wrap, module) of
        undefined ->
            io:format(standard_error,
                      "Module to run undefined.~n"
                      "Add configuration as command line arguments "
                      "(-start_wrap module <Module>)~n",
                      []),
            halt(1);
        {ok, Mod} ->
            case code:load_file(Mod) of
                {module, _} ->
                    Mod;
                {error, Reason} ->
                    io:format(standard_error,
                              "Couldn't load module due to reason: ~p~n",
                              [Reason]),
                    halt(1)
            end
    end.

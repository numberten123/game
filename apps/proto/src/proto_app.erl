%%%-------------------------------------------------------------------
%% @doc proto public API
%% @end
%%%-------------------------------------------------------------------

-module(proto_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    proto_sup:start_link().

stop(_State) ->
    ok.

%% internal functions

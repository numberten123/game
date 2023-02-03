%%%-------------------------------------------------------------------
%% @doc game public API
%% @end
%%%-------------------------------------------------------------------

-module(game_app).

-behaviour(application).

-include_lib("proto/include/all_pb.hrl").

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    game_sup:start_link().

stop(_State) ->
    ok.
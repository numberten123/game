%%%-------------------------------------------------------------------
%% @doc login public API
%% @end
%%%-------------------------------------------------------------------

-module(login_app).

-behaviour(application).

-include("common.hrl").

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    case login_sup:start_link() of
    	{ok, Pid} ->
    		init_tcp_server(),		%%初始化tcp线程池
    		{ok, Pid};
    	{error, _Reason} ->
			lager:error("start error, _Reason:~p~n", [_Reason]),
			exit(1)
	end.

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
%%初始化tcp
init_tcp_server() ->
	{ok, GamePort} = application:get_env(login, game_port),
	{ok, _} = ranch:start_listener(?TCP_TYPE_GAME, ranch_tcp, #{socket_opts => [{port, GamePort}, {keepalive, true}]}, tcp_server, []),
	ok.
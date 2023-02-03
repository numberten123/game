%%%-------------------------------------------------------------------
%% @doc login top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(login_sup).

-behaviour(supervisor).

-include("common.hrl").

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).


init([]) ->
	{ok, DataBaseOpt} = application:get_env(login, database),
	BackgroundGC = {background_gc, {background_gc, start_link, []},permanent, infinity, worker, [background_gc]},
	MasterMySQLPool = create_mysql_pool_spec(?POOL_GAME, DataBaseOpt), 		%% 游戏主数据库连接池
	BaseList = [MasterMySQLPool, BackgroundGC],		%%节点基本服务
    {ok, { {one_for_one, 5, 5}, BaseList}}.

%%====================================================================
%% Internal functions
%%====================================================================
create_mysql_pool_spec(Atom, OptList) ->
	{Atom, AtomList} = lists:keyfind(Atom, 1, OptList),
	LogPoolOptions	 = [{size,proplists:get_value(size, AtomList)},{max_overflow, proplists:get_value(max_overflow, AtomList)}],
	Encoding		 = proplists:get_value(encoding, AtomList),
	LogMySqlOptions	 = [{user, proplists:get_value(user, AtomList)},
		{password, proplists:get_value(password, AtomList)},
		{keep_alive, proplists:get_value(keep_alive, AtomList)},
		{database, proplists:get_value(database, AtomList)},
		{host, proplists:get_value(host, AtomList)},
		{port, proplists:get_value(port, AtomList)},
		{queries, ["SET NAMES " ++ Encoding]}
	],
	mysql_poolboy:child_spec(Atom, LogPoolOptions, LogMySqlOptions).
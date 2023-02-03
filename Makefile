all:
	./tool/gen_proto.sh
	@rebar3 compile
run:
	@rebar3 shell --sname game
prod:
	@rebar3 as prod tar
start:
	@./_build/default/rel/game/bin/game console
start-d:
	@./_build/default/rel/game/bin/game start
remote:
	@./_build/default/rel/game/bin/game remote_console
stop:
	@./tool/single_c/stop.sh
	@./_build/default/rel/game/bin/game stop
xls:
ifeq (${mod},all)
	@./tool/xls/make_all_erl.sh
else
	@./tool/xls/make_one_erl.sh ${mod}
endif

-module(agenda).
-export([create/0]).
-export([loop/0]).

create() -> spawn(agenda, loop, []).

loop() ->
	key = {tijd, make_ref()},
	ets:new(agenda, [named_table, public, ordered_set,key]),
	receive
		stop->ok
	end.
	

	
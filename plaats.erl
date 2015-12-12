-module(plaats).

-export([create/0, init/0, loop/1]).

create() ->
	Pid = spawn(?MODULE, init, []). % create returned process id

init() ->
	Tid = ets:new(plaatsen, [ordered_set, public]), 
	loop(Tid),										 
	{ok, plaatsen}.

loop(Tid) ->       
	receive
		%{getInfo, Pid} ->
		%	Pid ! {info, Info, self()},
		%	loop(Tid);

		{reserveer, {Tijd, Locatie}} ->
			ets:insert(plaatsen,{{Tijd, make_ref()}, Locatie}),
			loop(Tid);
		{verwijderPlaats, {Tijd, Locatie}} ->
			Key = ets:first(plaatsen),
			ets:delete(plaatsen, Key);

		_ ->
			loop(Tid)
	end.
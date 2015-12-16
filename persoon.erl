-module(persoon).

-export([create/0, init/0, loop/1, add/2]).

create() ->
	Pid = spawn(?MODULE, init, []). % create returned process id

init() ->
	Tid = ets:new(boekingen, [ordered_set, public]), % we maken de tabel boeking aan
	loop(Tid),										 % en we starten de loop
	{ok, boekingen}.

loop(Tid) ->       % we willen de loop boekingen laten toevoegen of verwijderen
	receive
		%{getInfo, Pid} ->
		%	Pid ! {info, Info, self()},
		%	loop(Tid);

		{reserveer, {Tijd, Duur, Afspraak}} ->
			ets:insert(boekingen,{{Tijd, make_ref()}, Duur, Afspraak}),
			loop(Tid);
		{verwijderBoeking, {Tijd, Duur, Afspraak}} ->
			Key = ets:first(boekingen),
			ets:delete(boekingen, Key);

		_ ->
			loop(Tid)
	end.


add(Pid, naam, voornaam, leeftijd, rank, status) ->
	Pid ! {self(), {naam, voornaam, leeftijd, rank, status}}.



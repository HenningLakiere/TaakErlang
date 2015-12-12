-module(auto).

-export([create/0, init/0, loop/1, add/3]).

create() ->
	Pid = spawn(?MODULE, init, []).

init() ->
	Tid = ets:new(autos, [ordered_set, public]), 
	loop(Tid),
	{ok, autos}.

loop(Tid) ->       % we willen de loop reservaties laten toevoegen of verwijderen
	receive
		%{getInfo, Pid} ->
		%	Pid ! {info, Info, self()},
		%	loop(Tid);

		{types, {Merk, Seats}} ->
				io:format("Merk: ", Merk),
				Tid ! {self(), ok};

		{reserveer, {Tijd, Duur, Afspraak}} ->
			ets:insert(autos,{{Tijd, make_ref()}, Duur, Afspraak}),
			loop(Tid);
		{verwijderBoeking, {Tijd, Duur, Afspraak}} -> %verwijderAutos?
			Key = ets:first(autos),
			ets:delete(autos, Key);

		_ ->
			loop(Tid)
	end.

add(Pid, Merk, Seats) ->
	Pid ! {self(), {Merk, Seats}}.

%whereIs(auto) ->
%	ets:lookup(auto, Pid)



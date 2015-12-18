-module(persoon).
-export([create/0, init/0, loop/1]).

create() ->
    spawn(?MODULE, init, []).

init() ->
	Tid = ets:new(boekingen, [ordered_set]),
	loop(Tid).

loop(Boekingen) ->
    receive
		{reserveer, {Starttijd, Eindtijd, Onderwerp}} ->
			Boekingen:insert({Starttijd, make_ref()}, Eindtijd, Onderwerp),
			loop(Boekingen);
	    
		stop -> ok
    end.
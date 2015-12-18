-module(activiteit).
-export([create/5, init/5, loop/5, doeBoekingen/4]).

create(Starttijd, Eindtijd, Onderwerp, Personen, Vervoersmiddel) ->
	spawn(?MODULE, init, [Starttijd, Eindtijd, Onderwerp, Personen, Vervoersmiddel]).

init(Starttijd, Eindtijd, Onderwerp, Personen, Vervoersmiddel) ->
	loop(Starttijd, Eindtijd, Onderwerp, [Personen], Vervoersmiddel).

loop(ST, ET, O, PRS, VRVR) ->
	receive
		{reserveer, {ST, ET, O}} ->
			lists:foreach(fun
				(P) ->
					P ! {reserveer, {{ST, make_ref()}, ET, O}}
			end, PRS),
			loop(ST, ET, O, PRS, VRVR);
	    
		stop -> ok
    end.

doeBoekingen(P, S, E, O) ->
	P ! {reserveer, {S, E, O}}.
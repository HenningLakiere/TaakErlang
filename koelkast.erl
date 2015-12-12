-module(koelkast).
-export([start/1, init/1, stop/1, plaats/2, neem/2]).
% Publieke functies

start(Voedsellijst) ->
	spawn(koelkast, init, [Voedsellijst]).

stop(Pid) ->
	Pid ! stop.

plaats(Pid, Voedsel) ->
	Pid ! {self(), {plaats, Voedsel}},
 	receive
 		A -> io:format("antwoord ~p~n", [A])
 	after
 		2000 -> io:format("geen antwoord~n")
 	end.

neem(Pid, Voedsel) ->
	Pid ! {self(), {neem, Voedsel}},
	receive
 		A -> io:format("antwoord ~p~n", [A])
 	after
 		2000 -> io:format("geen antwoord~n")
 	end.

% Interne functies
init(Voedsellijst) ->
	koelkast(Voedsellijst).

koelkast(Voedsellijst) ->
	io:format("koelkast start ~p~n", [Voedsellijst]),
 	receive
 		{Van, {plaats, Voedsel}} ->
 			io:format("plaats ~p~n", [Voedsel]),
 			Van ! {self(), ok},
 			koelkast([Voedsel | Voedsellijst]);
 		{Van, {neem, Voedsel}} ->
 			io:format("neem ~p~n", [Voedsel]),
 			case lists:member(Voedsel, Voedsellijst) of
 				true ->
 					Van ! {self(), {ok, Voedsel}},
 					koelkast(lists:delete(Voedsel, Voedsellijst));
 				false ->
 					Van ! {self(), niet_gevonden},
 					koelkast(Voedsellijst)
 			end;

 		stop ->
 			io:format("stop~n"),
 			ok;
 		_ ->
 			io:format("onbekend~n"),
 		ok
 	end.

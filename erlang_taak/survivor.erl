-module(survivor).
-export([start/0]).
-export([loop/0]).
-export([voegToeAanLogboek/1]).

start() -> spawn(survivor, loop, []).

loop() ->
	ets:new(logboek, [named_table, public, {keypos, 1}]),
	receive
		stop -> ok
	end.
	
voegToeAanLogboek(Args) ->
	ets:insert(logboek, Args).
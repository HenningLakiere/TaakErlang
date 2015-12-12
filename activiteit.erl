-module(activiteit).

-export([create/3, init/0, loop/3]).

%% We willen de activiteit module de personen, autos en plaatsen laten samenkomen
%% in een tabel zodat deze gegevens doorgegeven kunnen worden naar de ecalendar

create(AutoPid, PersoonPid, PlaatsPid) ->  %% we geven de Pid van auto, persoon en plaats
	spawn(?MODULE, init, []).			   %% mee om er zeker van te zijn dat deze vanaf 
										  %% het begin (de create) al bestaan

init() ->
    ets:info(activiteiten) =:= undefined orelse ets:delete(activiteiten),
	ets:new(activiteit, [public, named_table]),
	{ok, activiteiten}.

loop(Auto, Persoon, Plaats) ->
	receive
		{getInfo, Pid} ->
			Pid ! {info, Info, self()},
			loop(Auto, Persoon, Plaats);

		{setActiviteit, NieuweActiviteit} ->
			loop(Info, NieuweActiviteit, Plaats);

		{getActiviteit, Pid} ->
			Pid ! {activiteit, Activiteit, self()},
			loop(Auto, Persoon, Plaats);
		_ ->
			loop(Auto, Persoon, Plaats)

	end.


%% in de loop moeten we meegeven welke resources we juist
%% willen opvragen aan de hand van bijvoorbeeld de tijd
%% die voor elke resource uniek is

-module(testfile).
-export([create/0, init/0]).

create() ->
	ID = spawn(?MODULE, init, []).

init() ->
	%survivor:start(),

	Event_manager = event_manager:start(),

	Gilles = persoon:create(),
	Robin = persoon:create(),

	Auto = auto:create(),

	Starttijd = 1000,
	Eindtijd = 2000,
	Onderwerp = voetbal,
	Activiteit = activiteit:create(Starttijd, Eindtijd, Onderwerp, [Gilles, Robin], Auto),

	Event_manager:post({100, activiteit, doeBoekingen, [Activiteit, Starttijd, Eindtijd, Onderwerp]}).

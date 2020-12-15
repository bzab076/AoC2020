%% @author blaz
%% @doc @todo Add description to day15.


-module(day15).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).


part1() -> playGame(2020).

part2() -> playGame(30000000).

%% ====================================================================
%% Internal functions
%% ====================================================================

getInput() -> [16,1,0,18,12,14,19].



%% play memory game for turn N
%% previously called numbers are stored in Dict, which is ets implementation of Set 
play(N, LastElem, _, _, _, Iter) when N > Iter -> LastElem;
play(N, _, List, ListSize, Dict, Iter) when N == 1 -> play(N+1, lists:nth(N, List), List, ListSize,  Dict, Iter);
play(N, LastElem, List, ListSize, Dict, Iter) when N =<ListSize -> 
	ets:insert(Dict, {LastElem, N-1}),
	play(N+1, lists:nth(N, List), List, ListSize,  Dict, Iter );
play(N, LastElem, List, ListSize, Dict, Iter) ->
	    Val = ets:lookup(Dict, LastElem),
		case length(Val) > 0 of
			true -> {_, L} = hd(Val), NewVal = N - 1 - L;
		    false -> NewVal = 0
		end,
        ets:insert(Dict, {LastElem, N-1}),
		play(N+1, NewVal, List, ListSize, Dict, Iter).




%% starts playing the game with input data from getInput() and stoping at iteration Iter
playGame(Iter) -> play(1,0,getInput(), length(getInput()), ets:new(myset, [set]), Iter).
	
			  
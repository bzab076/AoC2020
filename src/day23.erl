%% @author blaz
%% @doc @todo Add description to day23.


-module(day23).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).

     
part1() -> Res = play(100),  %% play the game
		   I1 = string:str(Res, [1]),  %% find index of 1
           ResultList = lists:append(lists:sublist(Res, I1+1, 9 - I1), lists:sublist(Res, I1 -1)), %% rearrange the list which is the result of the game
           lists:foldl(fun(X, Acc) -> lists:append(Acc, integer_to_list(X)) end, [], ResultList).

part2() -> L1 = lists:zip(inputList(), lists:append(tl(inputList()), [10])), %% list of tuples (linked list) for input list
		   L2 = lists:map(fun(X) -> {X,X+1}  end, lists:seq(10,999999)), %% list of tuples (linked list) for the remaining values till 1000000
		   Store = ets:new(myset, [set]),
		   ets:insert(Store, L1), %% store linked list into ETS
		   ets:insert(Store, L2),
		   ets:insert(Store, {1000000, hd(inputList())}), 
		   move2(hd(inputList()), Store, 1000000, 1, 10000000),  %% play the game
		   {_,Next} = hd(ets:lookup(Store, 1)), %% get cup 1 and the two cups after it
		   {A,B} = hd(ets:lookup(Store, Next)),
		   A*B.


%% ====================================================================
%% Internal functions
%% ====================================================================


inputList() -> [6,4,3,7,1,9,2,5,8].
%%inputList() -> [3,8,9,1,2,5,4,6,7].  %% test string


%% a basic implementation of the game for part 1
%% basically, it is about cutting the input list and putting pieces back together
move(CurrentIndex, List, N, MaxN) when N > MaxN -> List; 
move(CurrentIndex, List, N, MaxN) -> MaxLen = length(List),
	                        CurrentCup = lists:nth(CurrentIndex + 1, List),
							RemovedCups = [lists:nth(((CurrentIndex + 1) rem MaxLen) + 1, List), lists:nth(((CurrentIndex + 2) rem MaxLen) + 1, List), lists:nth(((CurrentIndex + 3) rem MaxLen) + 1, List)],
							case CurrentCup == 1 of
								true -> Label = length(List);
								false -> Label = CurrentCup - 1
							end,
							DI = findDestinationIndex(Label, List, RemovedCups),
							NewList = lists:append(
										lists:append(removeElements(lists:sublist(List,DI), RemovedCups), RemovedCups), 
										removeElements(lists:sublist(List, DI + 1, MaxLen - DI), RemovedCups)),
							NewCurrentIndex = string:str(NewList, [CurrentCup]),
							move(NewCurrentIndex rem MaxLen, NewList, N + 1, MaxN).
							

findDestinationIndex(Label, List, RemovedList) ->
	case lists:member(Label, RemovedList) of
		true -> case Label == 1 of
					true -> NewLabel = length(List); 
					false -> NewLabel = Label - 1
				end,
			    findDestinationIndex(NewLabel, List, RemovedList);
		false -> string:str(List, [Label])
	end.

removeElements(List, RemovedList) -> lists:foldl(fun(E,Acc) -> lists:delete(E, Acc) end, List, RemovedList).
  
play(Moves) -> move(0, inputList(), 1, Moves).



%% a linked list implementation for part 2
%% linked list containing all tuples {cup, next cup} is stored in ETS fo better performance
move2(_, _, _, N, MaxN) when N > MaxN -> ok; 
move2(CurrentCup, Store, MaxLen, N, MaxN) ->
	                                    Tuple = ets:lookup(Store, CurrentCup),
										{CurEl, NextEl} = hd(Tuple),
										{_,NextNextEl} = hd(ets:lookup(Store, NextEl)),
										{_,NextNextNextEl} = hd(ets:lookup(Store, NextNextEl)),
                                        {_,NextCup} = hd(ets:lookup(Store, NextNextNextEl)),
                                        Dest = getDestination(CurrentCup, [NextEl, NextNextEl, NextNextNextEl], MaxLen),
                                        {_,DestNext} = hd(ets:lookup(Store, Dest)),
                                        ets:insert(Store, {CurEl, NextCup}),
										ets:insert(Store, {Dest, NextEl}),
										ets:insert(Store, {NextNextNextEl, DestNext}),
                                        move2(NextCup, Store, MaxLen, N + 1, MaxN).


getDestination(Cup, BlackList, MaxLen) ->
	case Cup == 1 of
		true -> NewCup = MaxLen; 
		false -> NewCup = Cup - 1
	end,
	case lists:member(NewCup, BlackList) of
		true -> getDestination(NewCup, BlackList, MaxLen);
		false -> NewCup
	end.
     
										


  
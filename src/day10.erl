%% @author blaz
%% @doc @todo Add description to day10.


-module(day10).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).


part1() -> length(lists:filter(fun(X) -> X==1 end, joltDiff(getInput()))) *  length(lists:filter(fun(X) -> X==3 end, joltDiff(getInput()))).

part2() -> fib3(possibleAdaptersList(getInput()), length(possibleAdaptersList(getInput())), 1 , 1, 1).



%% ====================================================================
%% Internal functions
%% ====================================================================

getInput() -> lists:append([0],lists:sort(inputfile:file2integers("input10.txt"))).

%% creates lits of jolt diffreneces between two adjacent adapters
joltDiff([]) -> [0];
joltDiff([_|T]) when T =:= []-> lists:append([3], joltDiff(T));
joltDiff([H|T]) -> lists:append([hd(T) - H], joltDiff(T)).


%% number of adapters that Nth adapter in the List can connect to
possibleAdapters(N, _, MaxL) when N==MaxL -> 1;
possibleAdapters(N, List, MaxL) -> 
	Element = lists:nth(N, List),
	length(lists:filter(fun(X) -> (X - Element) =< 3 end, lists:sublist(List, N+1, min(3,MaxL - N)))). 

%% List containing number of adapters that nth adapter can connect to. Values are in range 0-3.
possibleAdaptersList(List) -> lists:map(fun(N) -> possibleAdapters(N, List, length(List)) end, lists:seq(1, length(List))).


%% A tail recursion variation of tribonacci sequence. 
%% Current element is either sum of last 1, 2 or 3 elements, depending on a number of possible adapter combinations.
%% This will give us the result for part 2.
fib3(_, 0, Acc, _, _) -> Acc;
fib3(List, N, Acc, Acc1, Acc2) ->
	case lists:nth(N, List) of
		3 -> fib3(List, N -1, Acc + Acc1 + Acc2, Acc, Acc1);
        2 -> fib3(List, N -1, Acc + Acc1, Acc, Acc1);
        1 -> fib3(List, N -1, Acc, Acc, Acc1)
   end.

%% @author blaz
%% @doc @todo Add description to day9.


-module(day9).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).


part1() -> lists:nth(findFirstNoMatchIndex(inputfile:file2integers("/Users/blaz/eclipse-workspace/AoC2020ERL/input/input9.txt"),25), 
					 inputfile:file2integers("/Users/blaz/eclipse-workspace/AoC2020ERL/input/input9.txt")).

part2() -> Sublist = findSublist(inputfile:file2integers("/Users/blaz/eclipse-workspace/AoC2020ERL/input/input9.txt"),part1()),
		   lists:max(Sublist) + lists:min(Sublist).



%% ====================================================================
%% Internal functions
%% ====================================================================


%% list of all sums of two distinct elements in the List
availableSums([])   -> [];
availableSums(L) -> [X+Y|| X <- L, Y <- L, X<Y].

%% finds whether Nth element is a sum of two elements from the sublist of lenght Preamble immediately preceding the Nth element
isMatch(List,Preamble,N) -> lists:member(lists:nth(N, List), availableSums(lists:sublist(List, N - Preamble, Preamble))).

%% finds first index in the list whose element is not the sum of two elemens of preamble
findFirstNoMatchIndex(List, Preamble) -> findFirstNoMatchIndex(List, Preamble, Preamble + 1).
findFirstNoMatchIndex(List, Preamble, N) ->
	case isMatch(List, Preamble,N) of
		true -> findFirstNoMatchIndex(List, Preamble, N+1);
		false -> N
	end.

%% finds sublist of List whose sum of elements equals N
findSublist(List, N) -> findSublist(List, 1, 2, N).
findSublist(List, Start, Len, N) ->
	Sum = lists:foldl(fun(X,Acc) -> X+Acc end, 0, lists:sublist(List, Start, Len)),
    if
      Sum == N -> lists:sublist(List, Start, Len);
      Sum < N  -> findSublist(List, Start, Len  + 1, N);
      true ->  findSublist(List, Start + 1, 2, N)
   end.
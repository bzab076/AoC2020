%% @author blaz
%% @doc @todo Add description to day19.


-module(day19).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).

     
part1() -> 
	Rules = mapRule(0), 
	length(lists:filter(fun(X) -> lists:member(X, Rules) end, getInput())).  %% count strings that match rule 0

%% because brute force method failed, here is another solution
%% only consider input strings longer than 24 (not covered by rules in part 1) - strings that match part 1 rules are added at the end
%% first part of string (8 characters) must match rule 41 and the last 8 characters must match rule 31
%% convert input string into something like AAAAACBBBBB, where A represents 8 character substring matching rule 41, B matches rule 31, and C are others
%% in order for string to match rules of part 2 must be in form of AAAAABBB, where number of As must exceed number of Bs by at least 1
part2() -> 
	Rules42 = mapRule(42),
	Rules31 = mapRule(31),
	PotentialList =
	  lists:filter(fun(Y) -> endsWith(Y, Rules31) end, 
	  lists:filter(fun(X) -> startsWith(X, Rules42) end, 
		lists:filter(fun(Y) -> length(Y) > 24 end, getInput())
				  )),
	PotentialListABC = lists:map(fun(X) -> mapString(X, Rules42, Rules31) end, PotentialList),
    length( lists:filter(fun(X) -> (not lists:member(67, X)) and (string:find(X, "BA") =:= nomatch) and (2*length(string:find(X,"B")) < length(X)) end, PotentialListABC)) + part1().




%% ====================================================================
%% Internal functions
%% ====================================================================

%% reads rules from the (separate) input file into list of tuples
readRules() ->  lists:map(fun({K,V}) -> {K,  string:split(lists:delete(hd("\""),lists:delete(hd("\""), V)), " | ",all)} end, 
	lists:map(fun([X,Y]) -> {list_to_integer(X), string:trim(Y)} end, inputfile:file2list("rules19.txt",":"))).

%% reads input strings from input file into a list
getInput() -> lists:map(fun([X]) -> X end, inputfile:file2list("input19.txt","")).


startsWith(Str, PrefixList) -> lists:foldl(fun(Prefix, Acc) -> Acc or (string:find(Str, Prefix) =:= Str) end, false, PrefixList).
endsWith(Str, PrefixList) -> lists:foldl(fun(Prefix, Acc) -> Acc or (string:find(lists:reverse(Str), lists:reverse(Prefix)) =:= lists:reverse(Str)) end, false, PrefixList).


%% appends all strings in the list Elements to all strings in the list ListOfLists
appendAll([], ListOfLists) -> ListOfLists;
appendAll(Elements, []) -> Elements;
appendAll(Elements, ListOfLists) -> [lists:append(Elem,L)|| Elem <- Elements, L <- ListOfLists].

%% recursively resolve all rules and produce a list of strings that match rule
mapRule(Key) ->
	{K,V} = lists:keyfind(Key, 1, readRules()),
	if
	   length(hd(V)) == 1 ->  V; %% single char
       true ->   lists:append( lists:map(fun(Str) ->  lists:foldl(fun(Chr,Acc) ->  appendAll(Acc, mapRule(list_to_integer(Chr))) end, [], string:split(Str, " ", all)) end, V))   %% multiple strings
    end.


%% split string into 8 character substrings
split8([]) -> [];
split8(Str) -> lists:append([lists:sublist(Str, 8)], split8(lists:sublist(Str, 9, length(Str) - 8))).


%% map 8 character substring into A, B or C
%% A matches rule 42, A matches rule 31, C are others
mapString8(Str, List42, List31) -> 
    case lists:member(Str, List42) of
	  true -> "A";
      false -> case lists:member(Str, List31) of
			true -> "B";
            false -> "C"
	  end
	end.

%% convert Str into pattern AAACBBB, where each character represents substring of length 8
mapString(Str, List42, List31) -> lists:foldl(fun(X,Acc) -> lists:append(Acc, mapString8(X, List42, List31)) end, [], split8(Str)).









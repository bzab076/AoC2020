%% @author blaz
%% @doc @todo Add description to day2.


-module(day2).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).

part1() -> countValid(inputfile:file2list("input2.txt", ":")).

part2() -> countValid2(inputfile:file2list("input2.txt", ":")).

%% ====================================================================
%% Internal functions
%% ====================================================================

countValid([], Acc) -> Acc;
countValid([[Pol, Pass]|T], Acc) -> 
	case isValid(Pol, Pass) of
		true -> countValid(T, Acc+1);
        false -> countValid(T, Acc)
	end.

countValid(X) -> countValid(X,0). 

isValid(Pol, Pass) ->
	[Range,Char] = string:tokens(Pol, " "),
    [Lower, Upper] = lists:map(fun(X) -> erlang:list_to_integer(X) end, string:tokens(Range, "-")),
    Count = countChar(Char, Pass),
    (Count >= Lower) and (Count =< Upper).

countChar(Chr, [], Acc) -> Acc;
countChar(Chr, [H|T], Acc) -> 
	case hd(Chr) == H of
		true -> countChar(Chr, T, Acc + 1);
	    false -> countChar(Chr, T, Acc)
    end.

countChar(Chr, Pass) -> countChar(Chr, Pass, 0).

countValid2([], Acc) -> Acc;
countValid2([[Pol, Pass]|T], Acc) -> 
	case isValid2(Pol, Pass) of
		true -> countValid2(T, Acc + 1);
        false -> countValid2(T, Acc)
	end.

countValid2(X) -> countValid2(X,0). 

isValid2(Pol, Pass) ->
	[Range,Char] = string:tokens(Pol, " "),
    [Lower, Upper] = lists:map(fun(X) -> erlang:list_to_integer(X) end, string:tokens(Range, "-")),
    (lists:nth(Lower, string:trim(Pass)) == hd(Char)) xor (lists:nth(Upper, string:trim(Pass)) == hd(Char)).

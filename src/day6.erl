%% @author blaz
%% @doc @todo Add description to day6.


-module(day6).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).

part1() -> lists:foldl(fun(X,Sum) -> X + Sum end, 0,
				lists:map(fun(Y) -> length(lists:usort(Y)) end, getInput())
		   ).

part2() -> lists:foldl(fun(X,Sum) -> X + Sum end, 0,
				lists:map(fun(Y) -> length(commonelements(string:split(Y,":",all))) end, getInput2())
		   ).



%% ====================================================================
%% Internal functions
%% ====================================================================

getInput() -> string:split(lists:flatten(lists:map(fun(X) -> replaceempyline(X) end, inputfile:file2list("input6.txt",""))), "%", all).

getInput2() -> string:split(lists:flatten(
					lists:map( fun(Str) -> appendseparator(Str) end,
							  lists:map(fun(X) -> replaceempyline(X) end, inputfile:file2list("input6.txt",""))
					)
			), "%", all).


replaceempyline([[]]) -> ["%"];
replaceempyline(X) -> X.

%% append : after each persons answer for better handling
appendseparator([Str]) when Str =/= "%" -> [lists:append(Str,":")];
appendseparator([Str]) -> [Str].


commonelements([],_) -> [];
commonelements(_, []) -> [];
commonelements([H1|L1], L2) ->
	case lists:member(H1, L2) of
		true -> [H1 | commonelements(L1,L2)];
		false -> commonelements(L1,L2)
    end.

commonelements([X,[]]) -> X;
commonelements([X,Y]) -> commonelements(X,Y);
commonelements([H|T]) -> commonelements(H, commonelements(T)).



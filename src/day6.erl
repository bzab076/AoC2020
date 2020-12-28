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
				lists:map(fun(Y) -> length(commonElements(string:split(Y,":",all))) end, getInput2())
		   ).



%% ====================================================================
%% Internal functions
%% ====================================================================

getInput() -> string:split(lists:flatten(lists:map(fun(X) -> replaceEmpyLine(X) end, inputfile:file2list("input6.txt",""))), "%", all).

getInput2() -> string:split(lists:flatten(
					lists:map( fun(Str) -> appendSeparator(Str) end,
							  lists:map(fun(X) -> replaceEmpyLine(X) end, inputfile:file2list("input6.txt",""))
					)
			), "%", all).


replaceEmpyLine([[]]) -> ["%"];
replaceEmpyLine(X) -> X.

%% append : after each persons answer for better handling
appendSeparator([Str]) when Str =/= "%" -> [lists:append(Str,":")];
appendSeparator([Str]) -> [Str].


commonElements([],_) -> [];
commonElements(_, []) -> [];
commonElements([H1|L1], L2) ->
	case lists:member(H1, L2) of
		true -> [H1 | commonElements(L1,L2)];
		false -> commonElements(L1,L2)
    end.

commonElements([X,[]]) -> X;
commonElements([X,Y]) -> commonElements(X,Y);
commonElements([H|T]) -> commonElements(H, commonElements(T)).



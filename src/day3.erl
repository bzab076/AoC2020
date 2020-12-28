%% @author blaz
%% @doc @todo Add description to day3.


-module(day3).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).

part1() -> 
	Input = inputfile:file2list("input3.txt","\r\n"),
	lists:foldl(fun(X, Sum) -> hasTree(X) + Sum end, 0, lists:zip(Input, lists:seq(0,length(Input)-1))).

part2() -> 
	Input = inputfile:file2list("input3.txt","\r\n"),
	Params = [{1,1},{3,1},{5,1},{7,1},{1,2}],
	lists:foldl(fun(X, Prod) -> X * Prod end, 1, 
	    lists:map(fun({X,Y}) -> countTrees(X,Y,Input) end, Params)
    ).

%% ====================================================================
%% Internal functions
%% ====================================================================


%% is there a tree in a given row at given index; returns 1 or 0
hasTree(R, Idx) ->
	case lists:nth((Idx*3  rem length(R) + 1), R) == hd("#") of
		true -> 1;
		false -> 0
	end.

hasTree({R,I}) -> hasTree(lists:flatten(R),I).

%% is there a tree in a given row at given index; returns 1 or 0
%% takes into account right increment and down increment
hasTree2(Row, Idx, Right, Down) ->
	case lists:nth((Idx*Right  rem length(Row) + 1), Row) == hd("#") of
		true -> 1 * Down;
		false -> 0
	end.

hasTree2({R,I},Right) -> hasTree2(lists:flatten(R),I,Right,1).


%% takes every second row (element) in input list
countTrees(R,2, List) ->  lists:foldl(fun(X, Sum) -> hasTree2(X,R) + Sum end, 0, lists:zip(lf2(List), lists:seq(0,length(lf2(List))-1)));
%% counts trees for a given input List and right and down increments
countTrees(R,_, List) ->  lists:foldl(fun(X, Sum) -> hasTree2(X,R) + Sum end, 0, lists:zip(List, lists:seq(0,length(List)-1))).

%% removes every second element from the list
lf2([]) -> [];
lf2([X]) -> [X];
lf2([X, _ | T]) -> [X| lf2(T)].
%% @author blaz
%% @doc @todo Add description to day13.


-module(day13).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).


part1() -> {N, Time} = getDepartureTime(1013728,getInput(),1000),
		   trunc(Time/N)*(Time-1013728).

%% Part 2 solution is based on Chinese remainder.  https://www.dcode.fr/chinese-remainder
part2() -> 		
	Ns = lists:map(fun({X,_}) -> X end, getInput2()),
	ProdN = lists:foldl(fun(X,Acc) -> X*Acc end, 1,  Ns),
	CR = lists:foldl(fun({Pri,Rem},Acc) -> (Rem*trunc(ProdN/Pri)*inverseMod(trunc(ProdN/Pri), Pri))+Acc end, 0, getInput2()),
    ProdN - (CR rem ProdN).

%% ====================================================================
%% Internal functions
%% ====================================================================

%% this replaces input file
input13() -> [23,x,x,x,x,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,x,733,x,x,x,x,x,x,x,x,x,x,x,x,13,17,x,x,x,x,19,x,x,x,x,x,x,x,x,x,29,x,449,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,37].

getInput() -> lists:filter(fun(Y) -> Y =/= x end, input13()).

getInput2() -> lists:filter(fun({Y,_}) -> Y =/= x end, lists:zip(input13(), lists:seq(0, length(input13())-1))).
														

getDepartureTime(MyTime,Times,N) -> 
	Time = lists:max(lists:map(fun(X) -> X*N end, Times)),
    case Time >= MyTime of
       true -> {N, Time};
       false -> getDepartureTime(MyTime,Times,N+1)
    end.


inverseMod(X,P) -> {Inv, _} = hd(lists:filter(fun({_,R}) -> R==1 end, lists:map(fun(Y) -> {Y, X*Y rem P} end, lists:seq(0, P-1)))),
                  Inv.











   

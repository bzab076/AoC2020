%% @author blaz
%% @doc @todo Add description to day17.


-module(day17).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).


part1() -> length(runCycles3(6)).

part2() -> length(runCycles4(6)).



%% ====================================================================
%% Internal functions - all functions except isActive have 3 and 4 dimensional versions
%% ====================================================================

%% creates a list of vectors representing active cubes from the input list
%% coordinates are shifted by Offset
initialState3(Offset) -> lists:foldl(fun(Pair,Acc) -> lists:append(Acc, parseStr3(Pair, 1, Offset, [])) end, [], 
							%% convert initial list of strings into tuples containing index and string, e.g. {3,"#..#####"}
							lists:zipwith(fun(X,Y) -> {X,hd(Y)} end, lists:seq(1, length(inputfile:file2list("input17.txt",""))), inputfile:file2list("input17.txt",""))).

initialState4(Offset) -> lists:foldl(fun(Pair,Acc) -> lists:append(Acc, parseStr4(Pair, 1, Offset, [])) end, [], 
							lists:zipwith(fun(X,Y) -> {X,hd(Y)} end, lists:seq(1, length(inputfile:file2list("input17.txt",""))), inputfile:file2list("input17.txt",""))).


%% creates a list of vectors representing active cubes from the string representing one line in the input file
%% coordinates are shifted by Offset
parseStr3({_,[]}, _, _, Acc) -> Acc;
parseStr3({X,[H|T]}, N, Offset, Acc) when H == 35 -> parseStr3({X,T}, N+1, Offset, lists:append(Acc, [{X+Offset,N+Offset,1+Offset}]));
parseStr3({X,[_|T]}, N, Offset, Acc) -> parseStr3({X,T}, N+1, Offset, Acc).

parseStr4({_,[]}, _, _, Acc) -> Acc;
parseStr4({X,[H|T]}, N, Offset, Acc) when H == 35 -> parseStr4({X,T}, N+1, Offset, lists:append(Acc, [{X+Offset,N+Offset,1+Offset,1+Offset}]));
parseStr4({X,[_|T]}, N, Offset, Acc) -> parseStr4({X,T}, N+1, Offset, Acc).

%% sum of two tuples
addTuple3({X1,Y1,Z1}, {X2,Y2,Z2}) -> {X1 + X2, Y1 + Y2, Z1 + Z2}.
addTuple4({X1,Y1,Z1,W1}, {X2,Y2,Z2,W2}) -> {X1 + X2, Y1 + Y2, Z1 + Z2, W1 + W2}.

%% creates n-dimensional grid to accomodate 6 cycles: 6*2 + 8 (initial size)
fullGrid3(Cycles) -> [{X , Y, Z} || X <- lists:seq(1, 2*Cycles + length(inputfile:file2list("input17.txt",""))), 
									Y <- lists:seq(1, 2*Cycles + length(inputfile:file2list("input17.txt",""))),  
									Z <- lists:seq(1, 2*Cycles + 1)].
fullGrid4(Cycles) -> [{X , Y, Z, W} || X <- lists:seq(1, 2*Cycles + length(inputfile:file2list("input17.txt",""))), 
									   Y <- lists:seq(1, 2*Cycles + length(inputfile:file2list("input17.txt",""))),  
									   Z <- lists:seq(1, 2*Cycles + 1), W <- lists:seq(1, 2*Cycles + 1)].

%% list of one-step vectors representing all neighbors
neighbors3() -> [{I, J, K} || I <- lists:seq(-1, 1), J <- lists:seq(-1, 1), K <- lists:seq(-1, 1), not(( I == 0) and (J == 0) and (K == 0)) ].
neighbors4() -> [{I, J, K, L} || I <- lists:seq(-1, 1), J <- lists:seq(-1, 1), K <- lists:seq(-1, 1), L <- lists:seq(-1, 1), not(( I == 0) and (J == 0) and (K == 0) and (L == 0)) ].

%% returns 1, if a point (vector) is in the list of active points, 0 otherwise
isActive(Point, Grid) ->
	case lists:member(Point, Grid) of
		true -> 1;
		false -> 0
	end.

%% counts number of active neighbors which must be in the Grid
countNeighbors3(Point, Grid) -> lists:foldl(fun(M, Acc) -> Acc + isActive(addTuple3(Point,M), Grid) end, 0, neighbors3()).
countNeighbors4(Point, Grid) -> lists:foldl(fun(M, Acc) -> Acc + isActive(addTuple4(Point,M), Grid) end, 0, neighbors4()).

%% calculates new state according to puzzle rules
newState3(Point, ActiveList) ->
	N = countNeighbors3(Point, ActiveList),
	case lists:member(Point, ActiveList) of
		true ->  %% point is active
             case ((N==2) or (N==3)) of
				 true -> [Point];
				 false -> []
			 end;
        false -> %% point is inactive
             case N==3 of
				 true -> [Point];
				 false -> []
			 end
	end.


newState4(Point, ActiveList) ->
	N = countNeighbors4(Point, ActiveList),
	case lists:member(Point, ActiveList) of
		true ->  %% point is active
             case ((N==2) or (N==3)) of
				 true -> [Point];
				 false -> []
			 end;
        false -> %% point is inactive
             case N==3 of
				 true -> [Point];
				 false -> []
			 end
	end.

%% recursively apply cycles to ActiveList MaxC times
cycle3(C, MaxC, ActiveList) when C > MaxC -> ActiveList;
cycle3(C, MaxC, ActiveList) -> cycle3(C+1, MaxC, 
          lists:foldl(fun(Point, Acc) -> lists:append(Acc, newState3(Point, ActiveList)) end, [], fullGrid3(MaxC))						  
       ).


cycle4(C, MaxC, ActiveList) when C > MaxC -> ActiveList;
cycle4(C, MaxC, ActiveList) -> cycle4(C+1, MaxC, 
          lists:foldl(fun(Point, Acc) -> lists:append(Acc, newState4(Point, ActiveList)) end, [], fullGrid4(MaxC))						  
       ).


runCycles3(Cycles) -> cycle3(1,Cycles,initialState3(Cycles)).
runCycles4(Cycles) -> cycle4(1,Cycles,initialState4(Cycles)).


%% @author blaz
%% @doc @todo Add description to day24.


-module(day24).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).
 
part1() -> length(lists:foldl(fun(Dir, Acc) -> flipTile(Dir, {0,0}, Acc) end , [], getInput())).    %% create the list of black tiles in get the length of it    

part2() -> BlackTiles = lists:foldl(fun(Dir, Acc) -> flipTile(Dir, {0,0}, Acc) end , [], getInput()), %% create the initial list of black tiles
	       length(doDayFlips(BlackTiles, 100)). %% flip the grid 100 times



%% ====================================================================
%% Internal functions
%% ====================================================================


getInput() -> lists:map(fun([Line]) -> parseDirections(Line) end, inputfile:file2list("input24.txt","")).

%% parse input string into the list of directions
parseDirections([], Acc) -> Acc;
parseDirections([H|T], Acc) ->
	if
		H == 101 -> parseDirections(T, lists:append(Acc, [[H]])); %% e
        H == 119 -> parseDirections(T, lists:append(Acc, [[H]])); %% w
        true -> parseDirections(tl(T), lists:append(Acc, [[H,hd(T)]]))
	end. 

parseDirections(Str) -> parseDirections(Str, []).

%% change hex directions into cartesian coordinates
changeCoordinates({X,Y}, Dir) ->
	if
		Dir =:= "e" -> {X+2, Y};
		Dir =:= "w" -> {X-2, Y};
		Dir =:= "se" -> {X+1, Y-1};
		Dir =:= "sw" -> {X-1, Y-1};
		Dir =:= "ne" -> {X+1, Y+1};
		Dir =:= "nw" -> {X-1, Y+1}
    end.

%% gets a tile and aplies the list of directions to it. The Tile may end up in the BlackTiles list or not.
flipTile([], Tile, BlackTiles) -> 
	case lists:member(Tile, BlackTiles) of
		true -> lists:delete(Tile, BlackTiles);
		false -> lists:append(BlackTiles, [Tile])
	end;
flipTile([H|T], Tile, BlackTiles) -> flipTile(T, changeCoordinates(Tile,H), BlackTiles).

isBlack({X,Y}, BlackTiles) ->
	case lists:member({X,Y}, BlackTiles) of 
		true -> 1; 
		false -> 0 
	end.

countBlackNeighbors({X,Y}, BlackTiles) -> lists:foldl(fun({X2,Y2}, Acc) -> Acc + isBlack({X+X2, Y+Y2}, BlackTiles) end, 0, 
         [{2,0}, {-2,0}, {1, -1}, {-1,-1}, {1,1}, {-1,1}]).
		
%% should the tile be fliped according to the list of BlackTiles
shouldFlip(Tile, BlackTiles) -> Neigh = countBlackNeighbors(Tile, BlackTiles),
                case lists:member(Tile, BlackTiles) of
					true ->  (Neigh == 0) or (Neigh > 2); %% black
                    false -> Neigh==2 %% white
                end.

%% apply part 2 rule to the Tile. The tile may turn black or white according to the rule. A new list of black tiles is returned.
applyRule(Tile, BlackTiles, NewList) ->
       case lists:member(Tile, BlackTiles) of
		   true -> 
               case shouldFlip(Tile, BlackTiles) of
                  true -> NewList;
				  false -> lists:append(NewList, [Tile])
               end;
		   false ->
			    case shouldFlip(Tile, BlackTiles) of
                  true -> lists:append(NewList, [Tile]);
				  false -> NewList
               end
	   end.

%% apply rules to all tiles in the grid, i.e. a daily iteration
dayFlip(BlackList) -> 
	{Xs,Ys} = lists:unzip(BlackList),
	lists:foldl(fun(Tile, Acc) -> applyRule(Tile, BlackList, Acc) end, [], 
				[{X,Y}|| X <- lists:seq(lists:min(Xs)-2, lists:max(Xs)+2), Y <- lists:seq(lists:min(Ys)-1, lists:max(Ys)+1), (X + Y) rem 2 == 0]).

doDayFlips(BlackList, D, Days) when D > Days -> BlackList;
doDayFlips(BlackList, D, Days) -> doDayFlips(dayFlip(BlackList), D+1, Days).

doDayFlips(BlackList, Days) -> doDayFlips(BlackList, 1, Days).  
                   

		
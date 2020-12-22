%% @author blaz
%% @doc @todo Add description to day20.


-module(day20).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).

           %% sort tiles by number of other tiles that match at any edge
part1() -> SortedTiles = lists:sort(fun({Id1,N1}, {Id2,N2}) -> N1 < N2 end, lists:map(fun({Id, Tile}) -> {Id, countMatches({Id, Tile})} end , getInput())),
		   %% multiply ids of first 4 tiles from the list, which are corner tiles
           lists:foldl(fun(N,Acc) ->  {Id,_} = lists:nth(N, SortedTiles), list_to_integer(Id)*Acc  end, 1, lists:seq(1, 4)).

           %% create a big picture by assembling and flipping tiles and cutting edges
part2() -> BigPicture = createPicture(lists:map(fun(TR) -> lists:map(fun(TT) -> processTileTuple(TT) end, TR) end, assembleTiles(12))),
		   %% get maximum number of monsters out of 8 possible rotations/flips and calculate water roughness
		   countAllPixels(BigPicture) - 15*getMaxMonsters(BigPicture).



%% ====================================================================
%% Internal functions
%% ====================================================================

%% parse input file into lists of tuples {id, tile}
getInput() -> lists:map(fun(X) -> {lists:sublist(hd(hd(X)),6,4), lists:map(fun([Y]) -> Y end, lists:sublist(tl(X),10))} end, split12(inputfile:file2list("input20.txt",""))).

%% splits list into chunks of 12 elements
split12([]) -> [];
split12(Str) ->  lists:append([lists:sublist(Str, 12)], split12(lists:sublist(Str, 13, length(Str) - 12))).


%% list of all 8 edges of a tile (4 regular and 4 flipped edges)
tileEdges({Id, Tile}) -> 
	  Edges = [hd(Tile), lists:last(Tile), leftEdge(Tile), rightEdge(Tile)],
	  FlipedEdges = lists:map(fun(X) -> lists:reverse(X) end, Edges),
	  {Id, lists:append(Edges, FlipedEdges)}.

sideEdge(Tile, N) -> lists:foldl(fun(Row,Acc) -> lists:append(Acc, [lists:nth(N, Row)]) end, [], Tile).
leftEdge(Tile) -> sideEdge(Tile, 1).
rightEdge(Tile) -> sideEdge(Tile, length(hd(Tile))). 

%% does any edge matches any edge of the other tile
matchEdges(EdgList1, EdgList2) -> lists:member(true, [ E1 =:= E2 || E1 <- EdgList1, E2 <- EdgList2]).


%% do two tiles match along any of their edges
matchTiles(Tile, Tile) -> false;
matchTiles(Tile1, Tile2) -> 
         {_, EdgList1} =  tileEdges(Tile1),
		 {_, EdgList2} =  tileEdges(Tile2),
		 matchEdges(EdgList1, EdgList2).

%% match as 0 or 1
matchTilesN(Tile1, Tile2) -> 
     case matchTiles(Tile1, Tile2) of
		 true -> 1;
         false -> 0
	 end.

countMatches(Tile) -> lists:foldl(fun(T,Acc) -> Acc + matchTilesN(Tile, T) end, 0, getInput()).

countPixel([]) -> 0;
countPixel([H|T]) ->
	case H == 35 of
		true -> 1 + countPixel(T);
		false -> countPixel(T)
	end.

%% counts all pixels # in a tile/picture
countAllPixels(Picture) -> lists:foldl(fun(X,Acc) -> Acc + countPixel(X) end, 0, Picture).


%% ====================================================================
%% Matrix operations
%% ====================================================================

transpose([[]|_]) -> [];
transpose(M) ->
  [lists:map(fun hd/1, M) | transpose(lists:map(fun tl/1, M))].

flipHorizontal(M) -> lists:reverse(M).

flipVertical(M) -> lists:map(fun(Row) -> lists:reverse(Row) end, M).

%% get one of 8 possible matrix orientations by combining vertical flip, horizontal flip and transpose 
flip(Matrix, N) ->
	case N rem 8  of
		0 -> Matrix;
		1 -> transpose(Matrix);
	    2 -> flipHorizontal(Matrix);
        3 -> flipHorizontal(transpose(Matrix));
	    4 -> flipVertical(Matrix);
		5 -> flipVertical(transpose(Matrix));
	    6 -> flipVertical(flipHorizontal(Matrix));
        7 -> flipVertical(flipHorizontal(transpose(Matrix)))
	end.

cutEdges(Matrix) -> lists:map(fun(Row) -> lists:droplast(tl(Row)) end, lists:droplast(tl(Matrix))).
	
%% do tiles match at vertical edge
matchVertical(LeftTile, RightTile) -> lists:foldl(fun({L,R}, Acc) -> Acc and (lists:last(L) =:= hd(R)) end, true, lists:zip(LeftTile, RightTile)).

%% do tiles match at horizontal edge
matchHorizontal(UpTile, DownTile) -> lists:last(UpTile) =:= hd(DownTile).


%% ====================================================================
%% Part 2 functions
%% ====================================================================


appendIfLast(Elem, Row, LastRow) ->
	case Row =:= LastRow of
		true -> lists:append(Row, [Elem]);
        false -> Row
    end.
				
appendLast(Elem, ListsOfLists) -> lists:foldl(fun(Row, Acc) -> lists:append(Acc, [appendIfLast(Elem, Row, lists:last(ListsOfLists))] ) end, [], ListsOfLists).

%% assembles tiles into Size*Size matrix (e.g. 12*12) according to matching edges
%% the matrix contains tuples of {tileID, flipID}
assembleTiles(Size) -> lists:droplast(assembleTile(1,1,Size,[])).

%% we start at upper left corner with the tile 1657 which we know is a corner tile
%% then we recursively assemble the whole matrix
assembleTile(1,1,Size,_) -> assembleTile(2,1,Size,[[{"1657", 0}]]);
assembleTile(C,R,Size, Pic) when R > Size -> Pic;
assembleTile(C,R,Size, Pic) when C > Size -> assembleTile(1,R+1,Size, lists:append(Pic, [[]]));
assembleTile(C,R,Size, Pic) when C == 1-> assembleTile(C+1,R,Size, appendLast(findMatch(hd(hd(tl(lists:reverse(Pic)))), idList(Pic), fun matchHorizontal/2), Pic));
assembleTile(C,R,Size, Pic) -> assembleTile(C+1,R,Size, appendLast(findMatch(lists:last(lists:last(Pic)), idList(Pic), fun matchVertical/2), Pic)).

idList(Pic) -> lists:map(fun({Id,_}) -> Id end, lists:flatten(Pic)).

%% find a match of tile {Id,Fl} ignoring tiles from the BlackList (i.e. already used tiles)
%% match is found according to Matcher function which can either be matchHorizontal or matchVertical
findMatch({Id,Fl}, BlackList, Matcher) -> 
      {_,Tile} =  lists:keyfind(Id, 1, getInput()),
	  listMatch(Tile, Fl, lists:filter(fun({ID, _}) -> not lists:member(ID, BlackList) end, getInput()), Matcher).

%% get a match from the CandidateList (i.e. all tiles excluding BlackList)
listMatch(Tile, Fl, CandidateList, Matcher) -> listMatch(Tile, Fl, CandidateList, 1, Matcher).
listMatch(Tile, Fl,  CandidateList, N, Matcher) ->
	case N > length(CandidateList) of
		true -> {"null",0};
		false -> {OthId, OtherTile} = lists:nth(N, CandidateList),
			     FM = flipMatch(Tile, Fl, OtherTile, Matcher),
				 case FM == -1 of
					 true -> listMatch(Tile, Fl, CandidateList, N+1, Matcher);
					 false -> {OthId, FM}
				 end
	end.

%% try flipping the tile and find a match if exists
flipMatch(Tile1, Fl, Tile2, Matcher) -> flipMatch(Tile1, Fl, Tile2, 0, Matcher).
flipMatch(Tile1, _, Tile2, N, _) when N > 7 -> -1;
flipMatch(Tile1, Fl, Tile2, N, Matcher) ->
	case Matcher(flip(Tile1, Fl), flip(Tile2,N)) of
		true -> N;
		false -> flipMatch(Tile1, Fl, Tile2, N+1, Matcher)
	end.


concatTwoTiles([[]], Tile2) -> Tile2;
concatTwoTiles(Tile1, Tile2) -> lists:foldl(fun({LR, RR}, Acc) -> lists:append(Acc, [lists:append(LR, RR)]) end , [], lists:zip(Tile1, Tile2)).

%% concatenate a row of tiles
concatRowOfTiles(RowOfTiles) -> lists:foldl(fun(T,Acc) -> concatTwoTiles(Acc,T) end, [[]], RowOfTiles).

%% create a final picture by putting together all concatenated rows 
createPicture(TileMatrix) -> lists:foldl(fun(Row, Acc) -> lists:append(Acc, concatRowOfTiles(Row)) end, [], TileMatrix).


%% process a tuple {Id, Flip} to get a tile with the right orientation
processTileTuple({Id, Flip}) -> {_,Tile} =  lists:keyfind(Id, 1, getInput()),
								cutEdges(flip(Tile,Flip)).


%% coordinates of the monster
getMonster() -> [{18,0}, {0,1}, {5,1}, {6,1}, {11,1}, {12,1}, {17,1}, {18,1}, {19,1}, {1,2}, {4,2}, {7,2}, {10,2}, {13,2}, {16,2}].

%% is there a monster at coordinates Col, Row in the Picture
isMonster(Picture, Col, Row) -> 
	MonsterFound = lists:foldl(fun({X,Y}, Acc) ->  Acc and (lists:nth(Col + X, lists:nth(Row+Y, Picture)) == 35)  end, true, getMonster()),
	case MonsterFound of
       true -> 1;
       false -> 0
	end.

%% count all monsters in certain orientation of the picture
countMonsters(Picture) -> lists:foldl(fun(Y, AccY) ->  
									  AccY + lists:foldl(fun(X, AccX) -> AccX +  isMonster(Picture, X, Y) end, 0, lists:seq(1, length(hd(Picture)) - 19))  end, 
									  0, lists:seq(1, length(Picture) - 2)).


%% try all picture orientations and get the maximum number of monsters
getMaxMonsters(Picture) -> lists:max(lists:map(fun(F) -> countMonsters(flip(Picture,F)) end , lists:seq(0, 7))).



%% @author blaz
%% @doc @todo Add description to day12.


-module(day12).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).


part1() -> {Pos, _} = lists:foldl(fun(X,Acc) ->  move(Acc,X) end, {{0,0}, 69}, getInput()),
		   manhattan(Pos).

part2() -> {Pos, _} = lists:foldl(fun(X,Acc) ->  move2(Acc,X) end, {{0,0}, {10,1}}, getInput()),
		   manhattan(Pos).

%% ====================================================================
%% Internal functions
%% ====================================================================


getInput() -> lists:map(fun(Y) -> {hd(hd(Y)), list_to_integer(tl(hd(Y)))} end, inputfile:file2list("input12.txt","")).

manhattan({X,Y}) -> abs(X) + abs(Y).

move({{StartX,StartY}, Dir}, {Move, Len}) ->
	if
		Move == 69 -> {{StartX + Len, StartY}, Dir};  %% E
        Move == 87 -> {{StartX - Len, StartY}, Dir};  %% W
        Move == 78 -> {{StartX, StartY + Len}, Dir};  %% N
        Move == 83 -> {{StartX, StartY - Len}, Dir};  %% S
        Move == 82 -> {{StartX, StartY}, changeDirection(Dir, Len, 1)};   %% R
        Move == 76 -> {{StartX, StartY}, changeDirection(Dir, Len, -1)};  %% L
        Move == 70 ->  %% F
            if
                Dir == 69 -> {{StartX + Len, StartY}, Dir};  %% E
                Dir == 87 -> {{StartX - Len, StartY}, Dir};  %% W
                Dir == 78 -> {{StartX, StartY + Len}, Dir};  %% N
                Dir == 83 -> {{StartX, StartY - Len}, Dir}   %% S
           end
    end.


changeDirection(Dir, Angle, Rot) ->
	Angl = ((Angle div 90) * Rot + 4) rem 4,
	if
	    Dir == 69 -> 
			if
				Angl == 0 -> 69;
				Angl == 1 -> 83;
                Angl == 2 -> 87;
                Angl == 3 -> 78
			end;
        Dir == 87 -> 
            if
				Angl == 0 -> 87;
				Angl == 1 -> 78;
                Angl == 2 -> 69;
                Angl == 3 -> 83
			end;
        Dir == 78 -> 
			if
				Angl == 0 -> 78;
				Angl == 1 -> 69;
                Angl == 2 -> 83;
                Angl == 3 -> 87
			end;
        Dir == 83 -> 
			if
				Angl == 0 -> 83;
				Angl == 1 -> 87;
                Angl == 2 -> 78;
                Angl == 3 -> 69
			end
	end.


move2({{StartX,StartY}, {WayX, WayY}}, {Move, Len}) ->
	if
		Move == 69 -> {{StartX, StartY}, {WayX + Len, WayY}};  %% E
        Move == 87 -> {{StartX, StartY}, {WayX - Len, WayY}};  %% W
        Move == 78 -> {{StartX, StartY}, {WayX, WayY + Len}};  %% N
        Move == 83 -> {{StartX, StartY}, {WayX, WayY - Len}};  %% S
        Move == 82 -> {{StartX, StartY}, changeWaypoint({WayX, WayY}, Len, 1)};   %% R
        Move == 76 -> {{StartX, StartY}, changeWaypoint({WayX, WayY}, Len, -1)};  %% L
        Move == 70 -> {{StartX + Len*WayX, StartY + Len*WayY}, {WayX, WayY}}  %% F
    end.


changeWaypoint({WayX, WayY}, Angle, Rot) ->
	Angl = ((Angle div 90) * Rot + 4) rem 4,
	if
		Angl == 0 -> {WayX, WayY};
		Angl == 1 -> {WayY, -1*WayX};
        Angl == 2 -> {-1*WayX, -1*WayY};
        Angl == 3 -> {-1*WayY, WayX}
	end.
%% @author blaz
%% @doc @todo Add description to day11.


-module(day11).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).

part1() -> countOccupied(run(getInput(), 4, fun countChairs/3)).

part2() -> countOccupied(run(getInput(), 5, fun countChairs2/3)).


%% ====================================================================
%% Internal functions
%% ====================================================================

getInput() -> lists:map(fun(X) -> hd(X)  end, inputfile:file2list("input11.txt","")).


countChairs(X,Y, SeatingPlan) -> lists:foldl(fun({I,J},Acc) ->  Acc + isOccupied(X+I,Y+J, SeatingPlan) end, 0, [{0,1},{1,1},{1,0},{0,-1},{-1,-1},{-1,0},{-1,1},{1,-1}]).

isOccupied(X,_,_) when X=<0 -> 0;
isOccupied(_,Y,_) when Y=<0 -> 0;
isOccupied(X,Y, SeatingPlan) ->
	case (Y>length(SeatingPlan)) or (X>length(hd(SeatingPlan))) of
		true -> 0;
		false ->
			Row = lists:nth(Y, SeatingPlan),
			Seat = lists:nth(X, Row),
			case Seat == 35 of
				true -> 1;
				false -> 0
			end
	 end.


countChairs2(X,Y, SeatingPlan) -> lists:foldl(fun(Dir,Acc) ->  Acc + isOccupied2(X,Y,Dir, 1, SeatingPlan) end, 0, [{0,1},{1,1},{1,0},{0,-1},{-1,-1},{-1,0},{-1,1},{1,-1}]).


isOccupied2(X,Y, {I,J}, N, SeatingPlan) ->
	case ((Y+N*J)>length(SeatingPlan)) or ((X+N*I)>length(hd(SeatingPlan))) or ((Y+N*J)<1) or ((X+N*I)<1) of
		true -> 0;
		false ->
			Row = lists:nth((Y+N*J), SeatingPlan),
			Seat = lists:nth((X+N*I), Row),
			if
				Seat == 35 -> 1;
				Seat == 76 -> 0;
				Seat == 46 -> isOccupied2(X,Y, {I,J}, N+1, SeatingPlan);
			    true -> -1000  %% should never happen
			end
	 end.

%% new state of chair at coordinates X,Y. Can either be #, L or .
%% returns tuple {state, boolean}, where boolean denotes whether the state has changed
newState(X,Y, SeatingPlan, Threshold, CountFun) ->
		    Row = lists:nth(Y, SeatingPlan),
			Seat = lists:nth(X, Row),
			if 
				Seat == 35 ->
                    case CountFun(X,Y, SeatingPlan) >= Threshold of
                       true -> {76,true};
                       false -> {35,false}
                    end;
                Seat == 76 ->
                    case CountFun(X,Y, SeatingPlan) == 0 of
                       true -> {35,true};
                       false -> {76,false}
                    end;
                 true -> {46,false}
            end.


concatRow({R1,S1}, {R2,S2}) -> {lists:append(R1, [R2]), S1 or S2}.

%% returns tuple {row, boolean}, where boolean denotes whether the row has changed
newRow(Y, SeatingPlan, Threshold, CountFun) -> lists:foldl(fun(X, ACC) ->  concatRow(ACC, newState(X,Y, SeatingPlan, Threshold, CountFun)) end, {[],false}, lists:seq(1, length(hd(SeatingPlan)))). 

%% new seating plan after an iteration
%% returns tuple {plan, boolean}, where boolean denotes whether the seating plan has changed
newSeatingPlan(SeatingPlan, Threshold, CountFun) -> lists:foldl(fun(Y, ACC) ->  concatRow(ACC, newRow(Y, SeatingPlan, Threshold, CountFun)) end, {[],false}, lists:seq(1, length(SeatingPlan))). 

%% counts occupied seats in the seating plan
countOccupied(SeatingPlan) -> length(lists:filter(fun(X) -> X==35 end, lists:flatten(SeatingPlan))).

%% iterates through seating plans until they stabilize
run(SeatingPlan, Threshold, CountFun) -> {NewPlan, Status} = newSeatingPlan(SeatingPlan, Threshold, CountFun),
		case Status of
			true -> run(NewPlan, Threshold, CountFun);
			false -> NewPlan
        end.



	
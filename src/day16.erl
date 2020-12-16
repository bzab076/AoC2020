%% @author blaz
%% @doc @todo Add description to day16.


-module(day16).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).


part1() -> lists:foldl(fun(X,Acc) -> X+Acc end, 0, lists:filter(fun(N) -> valid4AnyField(N) == false end, lists:flatten(tl(getTickets())))).

%% A rather inefficient way of computing result for part 2. Needs optimization. It takes long time to complete. 
part2() -> 
	  {FL, _} = rulesByIndexFld(), %% get list of fields with names
      lists:foldl(fun(X,Acc) -> Acc*lists:nth(X, hd(getTickets())) end, 1, %% multiplies all items in my ticket that match criteria ...
				  lists:map(fun({X,_}) -> X end, lists:filter(fun({_,[X]}) -> string:find(X, "departure") =:= X end, %% get all field indexes that start with departure
	  FL))).


%% ====================================================================
%% Internal functions
%% ====================================================================


%% parse input file for all ticket rules. input file must contain ticket rules only
getTicketRules() -> lists:map( fun({F,{{[X1,Y1]},{[X2,Y2]}}}) -> {F,{{list_to_integer(X1), list_to_integer(Y1)},{list_to_integer(X2), list_to_integer(Y2)}}} end,
	                  lists:map(fun({F,[X,Y]}) -> {F,{{string:split(X, "-")}, {string:split(Y, "-")}}} end, 
                         lists:map(fun([X, Y]) -> {X, string:split(string:trim(Y), " or ")} end, inputfile:file2list("ticketRules.txt",":"))
					)).

%% parse input file for all tickets. input file must contain tickets only
getTickets() -> lists:map(fun(X) -> lists:map(fun(Y) -> list_to_integer(Y) end, X) end, inputfile:file2list("input16.txt",",")).

%% gets rule name from rule tuple
ruleName({Name,_}) -> Name.


checkNumber(Num, {_,{{X1,Y1},{X2,Y2}}}) -> ((Num >= X1) and (Num =< Y1)) or ((Num >= X2) and (Num =< Y2)).

%% is number N valid according to at least one rule
valid4AnyField(N) -> lists:foldl(fun(X,Acc) ->  Acc or checkNumber(N,X) end, false, getTicketRules()).

%% is ticket T valid, i.e. all its fields are valid
isTicketValid(T) -> lists:foldl(fun(N,Acc) -> Acc and valid4AnyField(N) end, true, T).

%% discard invalid ticket as per part 1 rules
discardInvalidTickects() -> lists:filter(fun(X) -> isTicketValid(X) end, getTickets()).

%% does the rule match fields at index Index for all valid tickets
ruleMatchesIndex(Rule, Index) -> lists:foldl(fun(X,Acc) -> Acc and checkNumber(lists:nth(Index, X),Rule) end, true, tl(discardInvalidTickects())).
			

%% constructs a list of tuples {FieldIndex, ListOfFieldNames}, where each field index has a list of fields that match criteria
rulesByIndex() ->  lists:sort(fun({_,A},{_, B}) -> length(A) =< length(B) end, 
	                   lists:map(fun(Idx) -> 
									{Idx,
									 lists:map(fun(X) -> ruleName(X) end, 
									 lists:filter(fun(R) -> ruleMatchesIndex(R,Idx) end, getTicketRules())	)  
									} end,
						      lists:seq(1, length(hd(getTickets())))	
				 )).


%% constructs a lists of tuples {FieldIndex, FieldName} by using function rulesByIndex()
rulesByIndexFld() -> lists:foldl(fun({I,L},Acc) -> {MyList, LastRules} = Acc, {lists:append([{I, deleteList(L,LastRules)}], MyList), L} end, {[],[]}, rulesByIndex()).

%% deletes all elements of list L2 from list L1. A new list is returned.
deleteList(L1,[]) -> L1;
deleteList(L1, [H|T]) -> deleteList(lists:delete(H, L1), T).
					 

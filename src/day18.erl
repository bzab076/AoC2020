%% @author blaz
%% @doc @todo Add description to day18.


-module(day18).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).

     
part1() -> lists:foldl(fun(X,Acc) -> Acc + compositeOperation(X, fun simpleOperationStr1/1) end, 0, getInput()).  

part2() -> lists:foldl(fun(X,Acc) -> Acc + compositeOperation(X, fun simpleOperationStr2/1) end, 0, getInput()).  


%% ====================================================================
%% Internal functions
%% ====================================================================


getInput() -> lists:map(fun([X]) -> lists:append(X," ") end, inputfile:file2list("input18.txt","")).

%% splits string according to parenthesis
%% three strings are returned Head, Middle and Tail, where Head and Tail may be empty strings
%% Middle is the string in first enclosed brackets, e.g. "a + (b + c*(d+e)) + f" ->  "a +", "b + c*(d+e)", "+ f"
splitByPrths(Str) -> splitByPrths(Str,0,[],[]).
splitByPrths([],_,[], HeadAcc) -> [HeadAcc, [], []];
splitByPrths([],_,InAcc, HeadAcc) -> [HeadAcc, lists:sublist(InAcc, length(InAcc)-1), []];
splitByPrths([H|T], InCount, InAcc, HeadAcc) ->
	if
		((InCount == 0) and (InAcc =:= [])) ->  
			if
				H == 40 -> NewHeadAcc = HeadAcc, NewInCount = InCount + 1, NewInAcc = InAcc; %% (
			    H == 41 -> NewHeadAcc = HeadAcc, NewInCount = InCount - 1, NewInAcc = InAcc; %% )
                true -> NewHeadAcc = lists:append(HeadAcc, [H]), NewInCount = InCount, NewInAcc = InAcc
			end,
			splitByPrths(T, NewInCount, NewInAcc, NewHeadAcc);
		((InCount == 0) and (InAcc =/= [])) -> 
                [HeadAcc, lists:sublist(InAcc, length(InAcc)-1), T];

		true -> 
			if
				H == 40 -> NewHeadAcc = HeadAcc, NewInCount = InCount + 1; %% (
			    H == 41 -> NewHeadAcc = HeadAcc, NewInCount = InCount - 1; %% )
                true -> NewHeadAcc = HeadAcc, NewInCount = InCount
			end,	
			NewInAcc = lists:append(InAcc,[H]),
            splitByPrths(T, NewInCount, NewInAcc, NewHeadAcc)
	end.



%% performs set of oprerations on a simple string without parenthesis, according to part 1 rules
simpleOperationStr1(Str) -> simpleOperation1(string:split(string:trim(Str), " ", all)).

simpleOperation1([]) -> 0;
simpleOperation1([Val]) -> list_to_integer(Val);
simpleOperation1([X,Opr,Y|T]) -> 
	if
		hd(Opr) == 43 -> Val = list_to_integer(X) + list_to_integer(Y); %% addition
		hd(Opr) == 42 -> Val = list_to_integer(X) * list_to_integer(Y)  %% multiplication
    end,
    simpleOperation1(lists:append([integer_to_list(Val)], T)).


%% performs set of oprerations on a simple string without parenthesis, according to part 2 rules
simpleOperationStr2(Str) -> simpleOperation2(string:split(string:trim(Str), " ", all)).

simpleOperation2([]) -> 0;
simpleOperation2([Val]) -> list_to_integer(Val);
simpleOperation2([X,Opr,Y|T]) -> 
	if
		hd(Opr) == 43 -> Val = list_to_integer(X) + list_to_integer(Y), simpleOperation2(lists:append([integer_to_list(Val)], T)); %% addition
		hd(Opr) == 42 -> list_to_integer(X) * simpleOperation2(lists:append([Y], T))  %% multiplication
    end.


%% splits a complex string that includes parenthesis and recursively applies function SimpleOperation
compositeOperation(Str, SimpleOperation) -> 
	    [H,M,T] = splitByPrths(Str),
		case length(M)==0 of
			true -> SimpleOperation(Str); %% it is a simple string
			false -> compositeOperation(lists:append([H, integer_to_list(compositeOperation(M, SimpleOperation)), " ", T]), SimpleOperation)
		end.




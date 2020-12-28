%% @author blaz
%% @doc @todo Add description to day4.


-module(day4).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).

part1() -> lists:foldl(fun(X,Sum) -> bool2Int(checkPass(X)) + Sum end,0, getInput()).

part2() -> lists:foldl(fun(X,Sum) -> bool2Int(checkPass2(X)) + Sum end,0, 
					   %% filter passwords according to part1 requirements
					   lists:filter(fun(X) -> checkPass(X) end, getInput2())).


%% ====================================================================
%% Internal functions
%% ====================================================================


getInput() -> string:split(lists:flatten(lists:map(fun(X) -> replaceEmpyLine(X) end, inputfile:file2list("input4.txt",""))), "%", all).

getInput2() -> string:split(lists:flatten(
							  lists:map(fun(S) -> addSpace(S) end, %% need to add additional space to split fileds, e.g. "hgt:170pid:186cm"
							      lists:map(fun(X) -> replaceEmpyLine(X) end, inputfile:file2list("input4.txt",""))
							   )
			  ), "% ", all).

replaceEmpyLine([[]]) -> ["%"];
replaceEmpyLine(X) -> X.

checkPass(PL) ->
	ReqFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"],
	lists:foldl(fun(X,Acc) -> (string:str(PL,X) > 0) and Acc end, true, ReqFields).

bool2Int(true) -> 1;
bool2Int(false) -> 0.

addSpace([Str]) -> [string:concat(Str, " ")].

checkPass2(PL) -> lists:foldl(fun(X,Acc) -> (checkProp(X) and Acc) end, true,  string:split(PL, " ", all)).

checkProp([]) -> true;
checkProp(Str) ->
	[K,V] = string:split(Str, ":", all),
	case K of
		"byr" -> (list_to_integer(V)>=1920) and (list_to_integer(V) =< 2002);
		"iyr" -> (list_to_integer(V)>=2010) and (list_to_integer(V) =< 2020);
		"eyr" -> (list_to_integer(V)>=2020) and (list_to_integer(V) =< 2030);
		"ecl" -> (V =:= "amb") or  (V =:= "blu") or (V =:= "brn") or (V =:= "gry") or (V =:= "grn") or (V =:= "hzl") or (V =:= "oth");
		"hcl" -> checkHcl(V);
		"hgt" -> checkHgt(V);
		"pid" -> (length(V)==9) and checkNum(V); 
		_ -> true
 	end.		  

checkHcl([H|Val]) -> 
	  case re:run(Val, "^[0-9a-f]+$") of
        {match, _} -> (length(Val) == 6) and  (H == 35);
        nomatch    -> false
    end;
checkHcl(_) -> false.

checkNum(Val) -> 
	  case re:run(Val, "^[0-9]+$") of
        {match, _} -> true;
        nomatch    -> false
    end.


checkHgt(Str) ->
	case string:slice(Str, length(Str)-2, 2) of
		"cm" -> (list_to_integer(string:slice(Str, 0, length(Str)-2)) >= 150) and (list_to_integer(string:slice(Str, 0, length(Str)-2)) =< 193);
        "in" -> (list_to_integer(string:slice(Str, 0, length(Str)-2)) >= 59) and (list_to_integer(string:slice(Str, 0, length(Str)-2)) =< 76);
		_ -> false
    end.
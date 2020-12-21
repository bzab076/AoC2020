%% @author blaz
%% @doc @todo Add description to day21.


-module(day21).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).

     
part1() ->  SL = lists:sort(fun({K1,V1}, {K2,V2}) -> length(V1) =< length(V2) end, processInputAllergens()), %% sort allergens, so that the one with only one ingredient appears on top
            AlgIgredients = lists:foldl(fun({_,V}, Acc) -> lists:append(Acc, V) end, [], removeAllIngredients(1, SL)), %% list of ingredients with allergens
			lists:foldl(fun([X,_], Acc) -> Acc + countSafeIngredients(string:split(X, " ", all),AlgIgredients) end, 0, inputfile:file2list("input21.txt"," (contains")).

part2() -> SL = lists:sort(fun({K1,V1}, {K2,V2}) -> length(V1) =< length(V2) end, processInputAllergens()), %% sort allergens, so that the one with only one igredient appears on top
            SortedIgredients = lists:sort(fun({K1,V1}, {K2,V2}) -> K1 < K2 end , removeAllIngredients(1, SL)), %% sort ingredients with allergens
			tl(lists:foldl(fun({K,V}, Acc) -> lists:append([Acc, "," ,hd(V)]) end, [], SortedIgredients)). %% construct result


%% ====================================================================
%% Internal functions
%% ====================================================================



%% parse an input line which has been split already into ingredients and allergens
parseLine([Ingredients, Allergens]) -> AlgList = string:split(lists:delete(41, string:trim(Allergens)), ", ", all),
									   lists:map(fun(A) -> {A, string:split(Ingredients, " ", all)} end, AlgList).

listIntersection(List1, List2) -> [X1 || X1<- List1, X2 <- List2, X1 =:= X2].

%% construct hashmap of allergens, where list of ingredients is intersection of all possible ingredients for that allergen
addAllergen({K, V}, []) -> [{K, V}];
addAllergen({K, V}, AlgList) ->
	case lists:keyfind(K, 1, AlgList) =:= false of
		true -> lists:append(AlgList, [{K, V}]);
		false -> {K2,V2} = lists:keyfind(K, 1, AlgList),
				 lists:append([{K,listIntersection(V,V2)}]  ,lists:delete({K2,V2}, AlgList))
	end.

concatAllergens(AlgList1, AlgList2) -> lists:foldl(fun(X,Acc) -> addAllergen(X,Acc) end, AlgList1, AlgList2).

%% get allergens from input file
processInputAllergens() -> lists:foldl(fun(Line,Acc) -> concatAllergens(Acc, parseLine(Line)) end, [], inputfile:file2list("input21.txt"," (contains")).

removeIngredient(I, {Alg, [I]}) -> {Alg, [I]};
removeIngredient(I, {Alg, Ings}) -> {Alg, lists:delete(I, Ings)}.

%% removes ingredient from hashmap 
removeIngredients({_,V}, AlgList) -> 
	case length(V) == 1 of
		true -> lists:sort(fun({_,V1}, {_,V2}) -> length(V1) =< length(V2) end, lists:map(fun({K2,V2}) ->  removeIngredient(hd(V), {K2,V2}) end, AlgList));
        false -> AlgList
	end.

%% recursively removes ingredients which are found to belong to another allergen
removeAllIngredients(N, AlgList) when N > length(AlgList) -> AlgList;
removeAllIngredients(N, AlgList) ->
	{K,V} = lists:nth(N, AlgList),
	case length(V) == 1 of
       true -> removeAllIngredients(N+1, removeIngredients({K,V}, AlgList));
       false -> AlgList
	end.
	
countNotMember(El, List) -> 
	case lists:member(El, List) of
		true -> 0;
		false -> 1
	end.

%% count ingredients not containing allergens
countSafeIngredients(IngList, AlgList) -> lists:foldl(fun(I,Acc) -> Acc + countNotMember(I,AlgList) end, 0, IngList).

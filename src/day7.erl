%% @author blaz
%% @doc @todo Add description to day6.


-module(day7).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).

part1() -> length(lists:usort(getContainingBagsR(["shiny gold"], getInput(), []))).

part2() -> countContainedBags("shiny gold", getInput()) - 1.  %% subtract 1 because shiny gold does not count



%% ====================================================================
%% Internal functions
%% ====================================================================

getInput() -> lists:map(fun({K, Vals}) -> {K, lists:map(fun(V) -> parseBag(V) end, Vals)}  end,
	             lists:map(fun([K,V]) -> {lists:flatten(string:split(K, " bags")), string:split(V, ", ", all)} end, 
				   lists:map(fun(X) -> string:split(X, " contain ") end, inputfile:file2list("input7.txt",""))
			  )).

%% converts string like "3 faded blue bags" into tuple {3,"faded blue"}
parseBag(Str) -> 
            H = hd(string:split(Str, " bag")),
			[K,V] = string:split(H, " "),
			case (string:length(K) == 0) or (K =:= "no") of
				true -> {};
			    false -> {list_to_integer(K), V}
            end.

%% checks whether a certain color C is contained in the list of bags, such as [{1,"shiny coral"},{5,"posh white"},{3,"wavy cyan"}]
containsColor(_, []) -> false;
containsColor(_, [H|T]) when H =:= {} -> false; 
containsColor(C, [H|T]) ->
	{K,V} = H,
	(C =:= V) or containsColor(C,T).

%% gets the list of bags that contain a given bag of color C
getContainingBags(_, []) -> [];
getContainingBags(C, List) -> lists:map(fun({K,V}) -> K end, lists:filter(fun({_, Values}) -> containsColor(C, Values) end, List)).

%% recursively finds bags that contain bags from a given list
getContainingBagsR([], GeneralList, ACC) -> ACC;
getContainingBagsR(ColorList, GeneralList, ACC) -> 
	   ParentColors = lists:usort(lists:append(lists:map(fun(X) -> getContainingBags(X, GeneralList) end, ColorList))),
	   getContainingBagsR(ParentColors, GeneralList, lists:merge(ACC, ParentColors)).


%% part 2

%% get list of bags contained in a given bag C; List must be the input list
%% for example: getContainedBags("shiny gold", day7:getInput())  returns [{1,"shiny coral"},{5,"posh white"},{3,"wavy cyan"}]
getContainedBags(_, []) -> [];
getContainedBags(C, List) -> 
	{K,Values} = hd(lists:filter(fun({K, Values}) -> K =:= C end, List)),
	case hd(Values) =:= {} of
		true -> [];
		false -> Values
	end.


%% counts bags in a given bag plus the bag itsef; List must be the input list
countContainedBags(Bag, List) ->
	ContainedBags = getContainedBags(Bag, List),
	case length(ContainedBags) == 0 of
		true -> 1;
		false -> lists:foldl(fun({K,V}, Acc) -> (K*countContainedBags(V,List)) + Acc end, 0, ContainedBags) + 1
    end.


%% @author blaz
%% @doc @todo Add description to 'day1'.


-module('day1').

%% ====================================================================
%% API functions
%% ====================================================================
-export([ part1/0, part2/0]).

-import(inputfile, [file2integers/1]).


%%part1() -> result1(hd(lists:filter(fun({X,Y}) -> X+Y == 2020 end, cartesian([1721, 979, 366, 299, 675, 1456])))).
part1() -> result1(hd(lists:filter(fun({X,Y}) -> X+Y == 2020 end, cartesian(inputfile:file2integers("input1.txt"))))).


%%part2() -> result2(hd(lists:filter(fun({X,Y,Z}) -> X+Y+Z == 2020 end, cartesian3([1721, 979, 366, 299, 675, 1456])))).
part2() -> result2(hd(lists:filter(fun({X,Y,Z}) -> X+Y+Z == 2020 end, cartesian3(inputfile:file2integers("input1.txt"))))).




%% ====================================================================
%% Internal functions
%% ====================================================================

result1({X,Y}) -> X*Y.
result2({X,Y,Z}) -> X*Y*Z.

cartesian([])   -> [];
cartesian(L) -> [{X,Y}|| X <- L, Y <- L].

cartesian3([])   -> [];
cartesian3(L) -> [{X,Y,Z}|| X <- L, Y <- L, Z <- L].


%% @author blaz
%% @doc @todo Add description to inputfile.


-module(inputfile).

%% ====================================================================
%% API functions
%% ====================================================================
-export([readlines/1, file2integers/1, file2list/1, file2list/2, resolveFileName/1]).

%%BaseInputDir = "/Users/blaz/eclipse-workspace/AoC2020ERL/input/".

resolveFileName([]) -> "";
resolveFileName(FileName) when hd(FileName) == 47 -> FileName;
resolveFileName(FileName) -> 
	BaseInputDir = "/Users/blaz/eclipse-workspace/AoC2020ERL/input/",
	BaseInputDir ++ FileName.


readlines(FileName) ->
    {ok, Data} = file:read_file(FileName),
    binary:split(Data, [<<"\r\n">>], [global, trim_all]).

file2integers(FileName) ->
   {ok, Bin} = file:read_file(resolveFileName(FileName)),
   lists:map(fun(X) -> erlang:list_to_integer(lists:delete($\n, lists:delete($\r, X))) end , string2lines(binary_to_list(Bin), []) ).
   %%string2lines(binary_to_list(Bin), []).

file2list(FileName) ->
   {ok, Bin} = file:read_file(resolveFileName(FileName)),
   string2lines(binary_to_list(Bin), []).

file2list(FileName, Token) ->
   {ok, Bin} = file:read_file(resolveFileName(FileName)),
   lists:map(fun(X) -> string:split(lists:delete($\n, lists:delete($\r, X)), Token, all) end , string2lines(binary_to_list(Bin), []) ).
   %%string2lines(binary_to_list(Bin), []).



%% ====================================================================
%% Internal functions
%% ====================================================================

string2lines("\n" ++ Str, Acc) -> [lists:reverse([$\n|Acc]) | string2lines(Str,[])];
string2lines([H|T], Acc)       -> string2lines(T, [H|Acc]);
string2lines([], Acc)          -> [lists:reverse(Acc)].



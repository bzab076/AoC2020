%% @author blaz
%% @doc @todo Add description to day5.


-module(day5).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).


part1() -> lists:max(
			 %% convert input list to binary string representation and convert to integers
			 lists:map(fun(X) -> list_to_integer(letter2bin(hd(X)),2) end,   
			    inputfile:file2list("input5.txt", "")
			 )
           ). 


part2() -> getMissigSeatID( lists:sort(
			 %% convert input list to binary string representation and convert to integers
			 lists:map(fun(X) -> list_to_integer(letter2bin(hd(X)),2) end,   
			    inputfile:file2list("input5.txt", "")
			 )
           )). 


%% ====================================================================
%% Internal functions
%% ====================================================================


%% maps ascii codes of F, B, R, L to ascii code of 0 and 1
letter2bin(70) -> 48;
letter2bin(66) -> 49;
letter2bin(82) -> 49;
letter2bin(76) -> 48;
letter2bin(Str) -> lists:map(fun(X) -> letter2bin(X) end, Str).


getMissigSeatID([H|T]) when H < hd(T) -1 -> H+1;
getMissigSeatID([_|T]) ->  getMissigSeatID(T).


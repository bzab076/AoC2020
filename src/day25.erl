%% @author blaz
%% @doc @todo Add description to day25.


-module(day25).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0]).
 
part1() -> transform(cardKey(), doorLoopSize()).



%% ====================================================================
%% Internal functions
%% ====================================================================


cardKey() -> 19241437.
doorKey() -> 17346587.

transform(Number, _, Iter, LoopSize) when Iter>LoopSize -> Number;
transform(Number, InitialNumber, Iter, LoopSize) -> transform(Number*InitialNumber rem 20201227, InitialNumber, Iter + 1, LoopSize).

transform(Number, LoopSize) -> transform(1, Number, 1, LoopSize).


		
doorLoopSize(Number, Iter, LoopSize) -> case Number == doorKey() of
											true -> Iter;
											false -> doorLoopSize(Number*7 rem 20201227, Iter + 1, LoopSize)
										end.

doorLoopSize() -> doorLoopSize(1,0,0).



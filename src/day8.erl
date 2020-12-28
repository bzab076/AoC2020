%% @author blaz
%% @doc @todo Add description to day8.


-module(day8).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).

part1() -> getAccumulator(getInput(), 1, [], false, 0).

%% Brute force method for checking at which index we must switch instruction. It checks all possible indexes, i.e. lists:seq(1,(length(getInput())
part2() -> {Accumulator, _} = hd(lists:filter(fun({_,B}) -> B end, lists:map(fun(N) -> getAccumulator2(getInput(),1,[],false,N,0) end, lists:seq(1,(length(getInput())))))),
		   Accumulator.

%% ====================================================================
%% Internal functions
%% ====================================================================


getInput() -> lists:map(fun(Y) -> {hd(Y), list_to_integer(hd(tl(Y)))} end, lists:map(fun(X) -> string:split(hd(X)," ") end, inputfile:file2list("input8.txt",""))).


%% tail recursion for part 1 
%% IndexList keeps track of already visited indexes, while IsLoop is a guard telling us whether the current index has been dealt with twice
getAccumulator(_, _, _, IsLoop, Acc) when IsLoop -> Acc;																					  
getAccumulator(InsList, Index, IndexList, _, Acc) -> 
      {Ins, Arg} = lists:nth(Index, InsList),
	  case Ins of
		  "acc" ->  getAccumulator(InsList, Index + 1, lists:append(IndexList, [Index]), lists:member(Index + 1, IndexList), Acc + Arg);
		  "jmp" ->  getAccumulator(InsList, Index + Arg, lists:append(IndexList, [Index]), lists:member(Index + Arg, IndexList), Acc);
          "nop" ->  getAccumulator(InsList, Index + 1, lists:append(IndexList, [Index]), lists:member(Index + 1, IndexList), Acc)
      end.


%% Variation of getAccumulator for use in part 2
%% Additional parameter is Chg which denotes the index at which instruction is switched from 'jmp' to 'nop' or vice versa
%% It also returns a tuple containing accumulated value along with the boolean denoting whether function stopped at the last instruction
getAccumulator2(InsList, Index, _, Loop, _, Acc) when Loop -> {Acc, Index > length(InsList)};																					  
getAccumulator2(InsList, Index, IndexList, _, Chg, Acc) -> 
      {Ins, Arg} = lists:nth(Index, InsList),
	  if 
		  Index /= Chg -> NewIns = Ins;
		  true -> 
			  case Ins of
				  "acc" ->  NewIns = "acc";
				  "jmp" ->  NewIns = "nop";
		          "nop" ->  NewIns = "jmp"
		      end
	  end,

	  case NewIns of
		  "acc" ->  getAccumulator2(InsList, Index + 1, lists:append(IndexList, [Index]), lists:member(Index + 1, IndexList) or ((Index +1)>(length(InsList))), Chg, Acc + Arg);
		  "jmp" ->  getAccumulator2(InsList, Index + Arg, lists:append(IndexList, [Index]), lists:member(Index + Arg, IndexList) or ((Index +Arg)>(length(InsList))), Chg, Acc);
          "nop" ->  getAccumulator2(InsList, Index + 1, lists:append(IndexList, [Index]), lists:member(Index + 1, IndexList)or ((Index +1)>(length(InsList))), Chg, Acc)
      end.

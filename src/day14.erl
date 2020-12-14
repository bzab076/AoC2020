%% @author blaz
%% @doc @todo Add description to day14.


-module(day14).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).

%% runs a v1 program and sums all values in memory 
part1() -> {_, Mem} = lists:foldl(fun(Instr,Acc) -> runProgram(Instr,Acc, fun applyIntruction/3) end, {"", []}, getInput()),
		 lists:foldl(fun({_,Val},Acc) -> Val+Acc end, 0, Mem).

%% runs a v2 program and sums all values in memory 
part2() -> {_, Mem} = lists:foldl(fun(Instr,Acc) -> runProgram(Instr,Acc, fun applyIntruction2/3) end, {"", []}, getInput()),
		 lists:foldl(fun({_,Val},Acc) -> Val+Acc end, 0, Mem).
	


%% ====================================================================
%% Internal functions
%% ====================================================================


getInput() -> lists:map(fun([X]) -> parseInput(X) end, inputfile:file2list("input14.txt","")).

%% parse input string into more manageable form
%% it can either be like {"mask","000000000000000000000000000000X1001X"} or
%% {42,100} for address value pairs
parseInput(Str) -> 
	case length(string:split(Str, "mask")) of
		1 -> {list_to_integer(hd(string:split(hd(tl(string:split(Str, "mem["))), "] = "))), list_to_integer(hd(tl(string:split(hd(tl(string:split(Str, "mem["))), "] = "))))}; %% mem
		2 -> {"mask", hd(tl(string:split(hd(tl(string:split(Str, "mask"))), " = ")))} %% mask
    end.

%% runs an Instruction on pair {CurrentMask, Memory} and returns the modified {CurrentMask, Memory} 
%% we can have either v1 or v2 of program by passing the correct InsFunction
runProgram(Instruction, {CurrentMask, Memory}, InsFunction) ->
	{A,B} = Instruction,
    case A =:= "mask" of
		true -> {B, Memory};
		false -> {CurrentMask, InsFunction(Instruction, CurrentMask, Memory)}
	end.


%% applies v1 Instruction using Mask on Memory and returns the new state of Memory 
applyIntruction(Instruction, Mask, Memory) ->
	{Addr, Val} = Instruction,
	BinVal = integer_to_list(Val, 2),
	Result = lists:zipwith(fun(A, B) -> if A==88 -> B; true -> A end end, Mask, lists:flatten(string:pad(BinVal, length(Mask), leading,48))),
    NewVal = list_to_integer(Result, 2),
	writeMem(Addr, NewVal, Memory).

%% applies v2 Instruction using Mask on Memory and returns the new state of Memory 
applyIntruction2(Instruction, Mask, Memory) ->
	{Addr, Val} = Instruction,
	BinAddr = integer_to_list(Addr, 2),
	OvrRes = lists:zipwith(fun(A, B) -> if A==48 -> B; true -> A end end, Mask, lists:flatten(string:pad(BinAddr, length(Mask), leading, 48))),
	AddrList = lists:map(fun(X) -> list_to_integer(X,2) end,   generateFloatingAddresses(OvrRes, [""])),
	writeMemL(AddrList, Val, Memory).


%% writes Val at addres Adds in Memory
%% the funcions uses custom implementation of set in the form of  [{Addr, Val}]
%% insertion into existing address overrides previous value
writeMem(Addr, Val, Memory) -> lists:append(lists:filter(fun({A,_}) -> A /= Addr end, Memory), [{Addr, Val}]).

%% writes Val at addreses in ListOfAddr in Memory
writeMemL(ListOfAddr, Val, Memory) -> lists:foldl(fun(Addr, Acc) -> writeMem(Addr, Val, Acc) end, Memory, ListOfAddr).

%% generates list of addresses represented by floating binary numbers
%% e.g. "X1" will generate list of two addresses ["01", "11"]
generateFloatingAddresses([], Acc) -> Acc;
generateFloatingAddresses([H|T], Acc) -> 
     case H == 88 of
        false -> generateFloatingAddresses(T, lists:map(fun(A) -> string:concat([H], A) end, Acc));
        true  -> generateFloatingAddresses(T, lists:append([lists:map(fun(A) -> string:concat("0", A) end, Acc), lists:map(fun(A) -> string:concat("1", A) end, Acc)]))
     end.






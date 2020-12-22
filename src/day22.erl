%% @author blaz
%% @doc @todo Add description to day22.


-module(day22).

%% ====================================================================
%% API functions
%% ====================================================================
-export([part1/0, part2/0]).

     
part1() -> lists:foldl(fun({X,Y}, Acc) -> X*Y + Acc end, 0, lists:zip(play(), lists:reverse(lists:seq(1, 50)))).  

part2() -> {_, Result} = play2(),
           lists:foldl(fun({X,Y}, Acc) -> X*Y + Acc end, 0, lists:zip(Result, lists:reverse(lists:seq(1, length(Result))))).  		   



%% ====================================================================
%% Internal functions
%% ====================================================================

%% get both decks from input file
deck1() -> lists:map(fun(X) -> list_to_integer(X) end, lists:sublist(lists:append(inputfile:file2list("input22.txt","")),2,25)).
deck2() -> lists:map(fun(X) -> list_to_integer(X) end, lists:sublist(lists:append(inputfile:file2list("input22.txt","")),29,25)).

%% play the game according to part 1 rules
play(Deck1, []) -> Deck1;
play([], Deck2) -> Deck2;
play(Deck1, Deck2) -> 
	case hd(Deck1) > hd(Deck2) of
		true -> play(lists:append([tl(Deck1), [hd(Deck1)], [hd(Deck2)]]), tl(Deck2));
		false -> play(tl(Deck1), lists:append([tl(Deck2), [hd(Deck2)], [hd(Deck1)]]))
	end.

play() -> play(deck1(), deck2()).



%% play the game according to part 2 rules
play2(Deck1, [],_) -> {1,Deck1};
play2([], Deck2,_) -> {2,Deck2};
play2(Deck1, Deck2, Plays) ->
	case lists:member({Deck1,Deck2}, Plays) of
       true -> {1,Deck1};   %% recursive rule, player1 wins
       false -> 
			case (hd(Deck1) < length(Deck1)) and (hd(Deck2) < length(Deck2)) of
				true -> {Winner,_} = play2(lists:sublist(tl(Deck1), hd(Deck1)), lists:sublist(tl(Deck2), hd(Deck2)), []), %% sub-game
						case Winner == 1 of
							true ->   play2(lists:append([tl(Deck1), [hd(Deck1)], [hd(Deck2)]]), tl(Deck2), lists:append(Plays, [{Deck1,Deck2}])); %% player 1 wins sub game
                            false ->  play2(tl(Deck1), lists:append([tl(Deck2), [hd(Deck2)], [hd(Deck1)]]), lists:append(Plays, [{Deck1,Deck2}])) %% player 2 wins sub game
                        end;
				false -> %% normal game
						case hd(Deck1) > hd(Deck2) of
							true ->  play2(lists:append([tl(Deck1), [hd(Deck1)], [hd(Deck2)]]), tl(Deck2), lists:append(Plays, [{Deck1,Deck2}]));
							false -> play2(tl(Deck1), lists:append([tl(Deck2), [hd(Deck2)], [hd(Deck1)]]), lists:append(Plays, [{Deck1,Deck2}])) 
						end
			end
      end.



play2() -> play2(deck1(), deck2(), []).
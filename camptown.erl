
%*****************************************************************************
%
%     a######n ###m    a######  ;##   ##   ### ,#######,   a####m   ,######c
%    a##  ,/" ######a##M#####M  ###  j#M   ### ##M  v##M ##M   j## ###,   F.
%   ,###MKM   ##  K##M j#####  ,##M  #M    ##F$######M\ ##F     ##M !7MK###
%   ##F      [##   KM  ### #####K##a#M  #v### ##M: K##m4##M    #####a,,,a##M
%  ;KKKKKKKKMKKKn     #KKM "#M"  ?#M\  9K##M  KKH   KKK *######MM 7KK###MMT
%
%                  a.k.a. erl-König, a.k.a. The Duke of erl
%*****************************************************************************

-module(camptown).
-export([races/1]).


%*****************************************************************************
% pivotRace(Horses, Pivot, [], [], 0) returns the horses that are faster and
% slower than the pivot
%*****************************************************************************
pivotRace([], _, Fast, Slow, N) ->
    {Fast, Slow, N};

pivotRace(Horses, Pivot, Fast, Slow, N) when length(Horses) =< 4 ->
    Result = lists:sort(lists:append(Horses,[Pivot])),
    {NewFast, SlowWPivot} = lists:splitwith(fun(A) -> A/=Pivot end, Result),
    NewSlow = lists:nthtail(1, SlowWPivot),
    {lists:append(Fast, NewFast), lists:append(Slow, NewSlow), N+1};
 
pivotRace(Horses, Pivot, Fast, Slow, N) ->
    % Pick four horses
    {Contestants, Rest} = lists:split(4, Horses),
    % Race them against the pivot
    Result = lists:sort(lists:append(Contestants,[Pivot])),
    % Separate the faster and slower ones
    {NewFast, SlowWPivot} = lists:splitwith(fun(A) -> A/=Pivot end, Result),
    NewSlow = lists:nthtail(1,SlowWPivot),
    % Race the rest
    pivotRace(Rest, Pivot, lists:append(Fast, NewFast), lists:append(Slow, NewSlow),N+1).


%******************************************************************************
% races(Horses) performs a race by racing horses 5 by 5. Displays # races.
%******************************************************************************
races(Horses) ->
    quicksort(Horses, 0).


%******************************************************************************
% quicksort(Horses, 0) sorts the Horses
%******************************************************************************
quicksort(Horse, N) when length(Horse) == 1 ->
    {Horse, N};

quicksort(Horses, N) when length(Horses) =< 5 ->
    {lists:sort(Horses), N+1};
 
quicksort(Horses, N) ->
    % Pick a horse in the middle
    PivotIndex = length(Horses) div 2,
    Pivot = lists:nth(PivotIndex, Horses),
    % Filter out the remaining horses
    HorsesWithoutPivot = lists:filter(fun(A) -> A/=Pivot end, Horses),
    % Let them race against the pivot
    {Fast, Slow, M1} = pivotRace(HorsesWithoutPivot, Pivot, [], [], 0),
    % Sort the fast ones
    {SortedFast, M2} = quicksort(Fast, 0),
    % Sort the slow ones
    {SortedSlow, M3} = quicksort(Slow, 0),
    % And voilà, there you are!
    {lists:append( [SortedFast, [Pivot], SortedSlow]), N+M1+M2+M3}.
 

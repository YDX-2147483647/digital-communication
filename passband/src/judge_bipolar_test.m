x = [1 1 1 -1 -1 -1 1 1 1];

%% Judge ideal wave
assert(isequal( ...
    judge_bipolar(x, 3), ...
    [1 0 1] ...
));

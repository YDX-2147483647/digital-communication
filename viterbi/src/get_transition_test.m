%% Shapes
for n = 1:3
    assert(isequal( ...
        size(get_transition(n)), ...
        [2^n 2^n] ...
    ));
end

%% 2^2 = 4 states
assert(isequal( ...
    get_transition(2), ...
    [
        1 0 1 0
        1 0 1 0
        0 1 0 1
        0 1 0 1
    ] ...
));

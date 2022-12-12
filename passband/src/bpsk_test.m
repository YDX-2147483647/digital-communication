x = [0 1 1 0];
n = length(x);

%% Sample Rate matches the length
for c = [2 3 9]
    for s = [1 2 5]
        assert(isequal(size(bpsk(x, c, s)), [1 n*c*s]));
    end
end


%% Periodicity
y = bpsk(x, 3, 10);
assert(isequal(y(1:30), - y(31:60)));
assert(isequal(y(1:30), - y(61:90)));
assert(isequal(y(1:30), + y(91:120)));


%% Default initial phase is 0.5
assert(isequal( ...
    bpsk(x, 3, 5, 'InitialPhase', 0), ...
    bpsk(x, 3, 5) ...
));


%% Invert initial phase
assert(all( ...
    bpsk(x, 3, 5, 'InitialPhase', pi) + bpsk(x, 3, 5) < 1e-6 ...
));

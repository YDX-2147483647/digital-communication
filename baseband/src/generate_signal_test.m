%% Size of output
signal = generate_signal(5, 0.2);
assert(isequal(size(signal), [1, 5]));

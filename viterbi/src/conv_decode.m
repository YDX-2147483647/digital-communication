function x = conv_decode(y, g)
%conv_decode - 用 Viterbi 算法解码卷积码
%
% x = conv_decode(y, g) 将 y 按卷积码解码，g 为生成矩阵

arguments
    y(1, :)
    g(:, :)
end


%% 补充辅助工具
% y(#output, #time)
y = reshape(y, size(g, 1), []);
n_time = size(y, 2);
log_n_state = size(g, 2) - 1;
n_state = 2 ^ log_n_state;

transition = get_transition(log_n_state);


%% 初始条件——初态必为 0

% 若当前处于 #state，则与接收偏离了 drift(#state, 2) （按 Hamming 距离度量）
% drift(#state, 1) 用于缓存
drift = zeros(n_state, 2);
drift(2:end, 2) = inf;

% 若 #time 时处于 #state，则 #time-1 时最可能处于 track(#state, #time)
% 将按 #time 升序填充
% #state 从 0 开始计数
track = zeros(n_state, n_time);


%% 更新候选者
for t = 1: n_time
    %% Save the old, i.e. drift(:, 1)
    drift(:, 1) = drift(:, 2);

    %% Fill the new, i.e. drift(:, 2) and track(:, t)
    for next_state = 0: n_state-1
        %% 1. Calculate possibilities
        % possible_last_states(#possibility)
        possible_last_states = find(transition(:, next_state+1)) - 1;
        
        % possible_histories(#possibility, #input)
        % (previous and next state) → concatenated state
        % → text → array.
        possible_histories = bitset(possible_last_states, log_n_state+1, ...
                                    bitget(next_state, log_n_state));
        possible_histories = dec2bin(possible_histories, log_n_state+1) - '0';

        % possible_outputs(#possibility, #output)
        possible_outputs = mod(possible_histories * g', 2);

        
        %% 2. Locate the minimal drift
        possible_drifts = ...
            drift(possible_last_states+1, 1) + ...
            hamming_distance(possible_outputs, y(:, t).');
        
        [new_drift, last_state_i] = min(possible_drifts);


        %% 3. Save it.
        drift(next_state+1, 2) = new_drift;
        track(next_state+1, t) = possible_last_states(last_state_i);
    end
end


%% 大决赛，读取结果
[~, last_state] = min(drift(:, 2));
last_state = last_state - 1;

x = zeros(1, n_time);
for t = n_time: -1: 1
    x(t) = bitget(last_state, log_n_state);
    last_state = track(last_state+1, t);
end

end
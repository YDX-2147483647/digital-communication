function transition = get_transition(log_n_state)
%get_transitions - 生成转移方阵
%
% transition = get_transition(log_n_state) 生成有 2 ^ log_n_state 个状态的转移方阵
%
% log_n_state 是以2为底 n_state 的对数。
%
% 状态（二进制）是最近输入历史，高位表示最近一次输入。
% transition(i, j) = “Can state_i → state_j happens?”.

arguments
    log_n_state(1,1) {mustBeInteger, mustBePositive}
end


n_state = 2 ^ log_n_state;

transition = zeros(n_state, n_state);

for s = 0: n_state-1
    next_zero = bitshift(s, -1);
    next_one = bitset(next_zero, log_n_state);

    transition(s+1, next_zero+1) = 1;
    transition(s+1, next_one+1) = 1;
end

end
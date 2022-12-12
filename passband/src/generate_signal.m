function signal = generate_signal(n, p)
%generate_signal - 生成二进制随机信号
%
% signal = generate_signal(n, p) 返回一个长为 n 的信号，码元只有0、1，其中1的概率为p。（即 Bernoulli 分布）
arguments
    n(1,1) {mustBePositive, mustBeInteger}
    p(1,1) {mustBePositive, mustBeNumeric, mustBeLessThanOrEqual(p,1)}
end

signal = rand(1, n) < p;

% logical → numbers
signal = 1 * signal;

end
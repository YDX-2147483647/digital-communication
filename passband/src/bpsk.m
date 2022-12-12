function y = bpsk(x, periods_per_symbol, samples_per_period, options)
%bpsk - binary phase shift keying
%
% y = bpsk(x, carrier, sampling) 将数字序列 x 转换为波形 y，载波频率是 carrier 倍码率，采样率是 sampling 倍载波频率。
% y = bpsk(x, carrier, sampling, "InitialPhase", phi) 将数字序列 x 转换为波形 y，载波初相为 phi。

arguments
    x(1,:)
    periods_per_symbol(1,1) {mustBeInteger, mustBePositive}
    samples_per_period(1,1) {mustBeInteger, mustBePositive}
    options.InitialPhase(1,1) = 0.
end

n = length(x);

%% 生成单个码元的载波
% t 是旋转周数，等于 f_carrier × time。
t = 0: 1/samples_per_period: periods_per_symbol;
t = t(1: end-1);  % drop the last
carrier = cos(2 * pi * t + options.InitialPhase);

%% 生成波形
% x → y: 1 → carrier, 0 → -carrier.
y = carrier.' * (2*x - 1);
% flatten
y = reshape(y, 1, []);

end
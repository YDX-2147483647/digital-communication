function s = judge_bipolar(x, samples_per_symbol)
%judge_bipolar - 双极性波形抽样判决
%
% s = judge_bipolar(x) 将双极性波形 x 抽样判决为数字序列 s

arguments
    x(1,:)
    samples_per_symbol(1,1) {mustBeInteger, mustBePositive}
end

x = reshape(x, samples_per_symbol, []);
s = x(floor(samples_per_symbol / 2), :) > 0;
% logical → numbers
s = 1 * s;

end
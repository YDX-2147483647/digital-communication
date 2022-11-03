function y = rz(x, f, options)
%rz - 归零（return-to-zero）波形
%
% y = rz(x, f) 将数字序列 x 转换为波形 y，波形采样率为符号率的f倍。
% y = rz(x, f, DutyRatio=0.2) 同上，只是占空比为 0.2。（默认为 0.5）

arguments
    x(1,:)
    f(1,1) {mustBeFinite, mustBePositive}
    options.DutyRatio (1,1) {mustBePositive, mustBeLessThan(options.DutyRatio,1)} = 0.5
end

n_nonzeros = round(f * options.DutyRatio);
n_zeros = f - n_nonzeros;

% 按每个码元的波形分组，先构造矩阵
y_mat = x' * [ones(1, n_nonzeros) zeros(1, n_zeros)];
% 然后压平
y = reshape(y_mat.', 1, []);

end
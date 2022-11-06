function y = hdb(x, order, options)
%hdb - High Density Bipolar
%
% y = hdb(x, 3) 将 x 按 HDB3 编码。
% y = hdb(x, 5, 'FirstMark', 1) 将 x 按 HDB5 编码，首个“1”编为 +1。
%
% HDB：
%   - 基础规则：0 → 0，1 → ±1 (alternatively). (same as AMI)
%   - 连续0 → 00…0V / B0…0V。（保证编码后连零数量不超过 order）
%     - V (Violation) 同时满足两个条件：交替 ±1、极性与前一号相同。
%     - V 的两个条件可能矛盾，于是要引入 B (Balance)。
%
% 选项：
%   - FirstMark：首个“1”的编码，取 ±1。
%   - FirstViolation：首个V的选取方法，±1 人为指定，0 不限制。
%
% 无论是哪种选项组合，再译码后都相同。
%
% 输出仍是数字信号，不涉及具体波形。

arguments
    x(1,:)
    order(1,1) {mustBeInteger, mustBePositive}
    options.FirstMark(1,1) {mustBeMember(options.FirstMark, [-1 +1])} = -1
    options.FirstViolation(1,1) {mustBeMember(options.FirstViolation, [-1 0 +1])} = 0
end

y = zeros(size(x));

last_mark = - options.FirstMark;
last_v = - options.FirstViolation;
n_zeros = 0;

for i = 1:length(x)
    % Count zeros
    if x(i)
        n_zeros = 0;
    else
        n_zeros = n_zeros + 1;
    end

    % Encode
    if x(i)
        y(i) = - last_mark;
        last_mark = y(i);

    elseif n_zeros > order
        % If the conditions conflict with each other, introduce a B.
        if last_mark == last_v
            first_zero = i + 1 - n_zeros;
            y(first_zero) = - last_v;
            last_mark = y(first_zero);
        end

        y(i) = last_mark;
        last_v = y(i);
        last_mark = y(i);

        % We have encoded it to V, so let's reset the counter.
        n_zeros = 0;
    end
end

end
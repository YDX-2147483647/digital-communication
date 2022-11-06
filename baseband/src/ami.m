function y = ami(x, first_mark)
%ami - Alternative Mark Inversion 
%
% y = ami(x) 将 x 按 AMI 编码。（默认首个“1”编为 -1）
% y = ami(x, 1) 将 x 按 AMI 编码，首个“1”编为 +1。
%
% AMI：0 → 0，1 → ±1 (alternatively).
%
% 输出仍是数字信号，不涉及具体波形。

arguments
    x(1,:)
    first_mark(1,1) {mustBeMember(first_mark, [-1 +1])} = -1
end

y = x;

% 顺序遍历信号，遇一则交替传号。
next_mark = first_mark;
for i = 1:length(x)
    if x(i)
        y(i) = next_mark;
        next_mark = -next_mark;
    end
end

end
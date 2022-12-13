function v = diff_code(u)
%diff_code - 差分码
%
% v = diff_code(u) 将数字序列 u 转换为差分数字序列 v

arguments
    u(1,:)
end

% 首个码元的相位仍有歧义，浪费之。
v = mod([0 cumsum(u)], 2);

end
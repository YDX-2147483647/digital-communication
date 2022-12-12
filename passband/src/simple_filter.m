function y = simple_filter(x, h)
%simple_filter - 简易滤波器
% y = simple_filter(x, h) 单位冲激响应为 h 的系统输入 x 时的输出

arguments
    x(1,:)
    h(1,:)
end

y = conv(x, h);
y = y(1: length(x));

end
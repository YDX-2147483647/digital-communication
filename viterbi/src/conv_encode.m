function y = conv_encode(x, g)
%conv_encode - 按卷积码编码
%
% y = conv_encode(x, g) 将 x 按卷积码编码，g 为生成矩阵
%
% g 的每一行代表一个输出码元，每一列代表一个输入码元。

arguments
    x(1, :)
    g(:, :)
end

y = mod(conv2(x, g), 2);
y = y(:, 1: length(x));
y = reshape(y, 1, []);
    
end
%% 编码
fprintf("## 编码\n\n");

b = [1 1 0 1 1 1 1 1 0 0];
fprintf("- 信源序列 b:    %s.\n", join(string(b), ",    "));

g = [1 1 1; 1 0 1];
c = conv_encode(b, g);
fprintf("- 编码序列 c: %s.\n\n", join(string(c), ", "));


%% 译码
fprintf("## 译码\n\n");

d = conv_decode(c, g);
fprintf("- 译码序列 d:    %s.\n\n", join(string(d), ",    "));

if isequal(d, b)
    fprintf("✓ 译码全部正确。\n\n")
else
    fprintf("✗ 译码错了 %d 位。\n\n", sum(abs(d - b)));
end


%% 纠错
fprintf("## 纠错\n\n");

error_i = randi(numel(c), 1, 2);
e = zeros(size(c));
e(error_i) = 1;
fprintf("- 错误位置:   %s.\n", join(string(e), ", "));

disturbed = bitxor(c, e);
fprintf("- 接收序列:   %s.\n", join(string(disturbed), ", "));
recovered = conv_decode(disturbed, g);
fprintf("- 译码序列:      %s.\n\n", join(string(recovered), ",    "));
if isequal(recovered, b)
    fprintf("✓ 译码全部正确。\n\n")
else
    fprintf("✗ 译码错了 %d 位。\n\n", sum(abs(recovered - b)));
end

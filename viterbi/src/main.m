%% 编码
fprintf("## 编码\n\n");

b = [1 1 0 1 1 1 1 1 0 0];
fprintf("- 信源序列 b:    %s.\n", join(string(b), ",    "));

g = [1 1 1; 1 0 1];
c = conv_encode(b, g);
fprintf("- 编码序列 c: %s.\n", join(string(c), ", "));

d = conv_decode(c, g);
fprintf("- 译码序列 d:    %s.\n\n", join(string(d), ",    "));

if isequal(d, b)
    fprintf("✓ 译码全部正确。\n")
else
    fprintf("✗ 译码错了 %d 位。\n", sum(abs(d - b)));
end

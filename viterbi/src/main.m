%% 编码
fprintf("## 编码\n\n");

b = [1 1 0 1 1 1 1 1 0 0];
fprintf("- 信源序列 b:    %s.\n", join(string(b), ",    "));

g = [1 1 1; 1 0 1];
c = conv_encode(b, g);
fprintf("- 编码序列 c: %s.\n\n", join(string(c), ", "));

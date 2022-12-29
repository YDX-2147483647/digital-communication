function d = hamming_distance(a, b)
%hamming_distance - Hamming 距离
%
% d = hamming_distance(a, b) 计算 a 与 b 间的 Hamming 距离
%
% 如果 a 或（和）b 有多行，每行分别比较。

arguments
    a(:, :)
    b(:, :)
end

d = sum(abs(a - b), 2);

end
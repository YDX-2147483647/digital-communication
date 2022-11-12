% 零的概率
prob = [1e-2, .1: .2: .9, 1 - 1e-2];
l = 10000; % 数字序列长
n = 10; % 重复次数


figure('WindowState', 'FullScreen');
hold on;

for p = 1 - prob
    raw_set = generate_signal(n * l, p);
    wave_set = rz(ami(raw_set), 8);
    wave_set = reshape(wave_set, [], n);

    [pxx_set, w] = periodogram(wave_set);
    pxx = sum(pxx_set, 2);

    plot(w / pi, 10 * log10(pxx));
end

title('不同信源最终的功率谱（多次平均）');
xlabel('$\omega / \pi$ (rad/sample)', 'Interpreter', 'latex');
ylabel('功率 (dB / (rad/sample))');
l = legend(string(prob));
title(l, '零的概率');
grid on;
hold off;

exportgraphics(gcf(), '../fig/AMI-variant-p-smooth.jpg');

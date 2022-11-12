% 零的概率
prob = [1e-2, .1: .2: .9, 1 - 1e-2];

figure('WindowState', 'FullScreen');
hold on;

for p = 1 - prob
    raw = generate_signal(1000, p);
    ami_seq = ami(raw);
    ami_wave = rz(ami_seq, 8);
    [pxx, w] = periodogram(ami_wave);
    plot(w / pi, 10 * log10(pxx));
end

title('不同信源最终的功率谱');
xlabel('$\omega / \pi$ (rad/sample)', 'Interpreter', 'latex');
ylabel('功率 (dB / (rad/sample))');
l = legend(string(prob));
title(l, '零的概率');
grid on;
hold off;

exportgraphics(gcf(), '../fig/AMI-variant-p.jpg');

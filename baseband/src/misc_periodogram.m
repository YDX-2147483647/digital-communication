% 几种展示功率谱的方法

l = 10000; % 数字序列长
p = 0.3; % 1 的概率
n = 10; % 重复次数

%% 生成一系列原始功率谱
raw_set = generate_signal(n * l, p);
wave_set = rz(ami(raw_set), 8);
wave_set = reshape(wave_set, [], n);
[pxx_set, w] = periodogram(wave_set);


%% 处理
powers = [ ...
    pxx_set(:,1) ...
    movmean(pxx_set(:, 1), 10) ...
    sum(pxx_set, 2) ...
];
labels = ["单次原始" "单次滑动平均" "多次平均"];


%% 绘图
f = figure('Position', [100 100 1000 500]);

for i = 1:size(powers, 2)
    subplot(1,3,i);
    
    plot(w / pi, 10 * log10(powers(:, i)));
    title(labels(i));
    
    xlabel('$\omega / \pi$ (rad/sample)', 'Interpreter', 'latex');
    ylabel('功率 (dB / (rad/sample))');
    grid on;
end

exportgraphics(gcf(), '../fig/misc-periodogram.jpg');

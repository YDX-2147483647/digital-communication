%% 1 生成的信号。
fprintf("## 1 生成的信号\n\n")
raw = generate_signal(100, 0.5);
raw(1:10)


%% 2 调制
fprintf("## 2 调制\n\n")
modulated = bpsk(raw, 10, 100 / 10);

% 绘图 BPSK
figure("Name", "序列、波形开头");

subplot(2, 1, 1);
stem(raw(1: 10));
title("信源序列");
xlabel("码元序号");
ylim([-0.2 1.2]);
% 这里画序列，而后面画波形，二者默认长度不完全相同。
xlim([1 11]);

subplot(2, 1, 2);
plot(modulated(1: 100 * 10));
xlabel("样本序号");
title("调制波形");

fprintf("请看序列、波形开头。\n");
exportgraphics(gcf(), "../fig/BPSK.jpg");

% 绘图 BPSK-freq
figure("Name", "功率谱");
periodogram(modulated);
title("调制波形的功率谱");

fprintf("请看功率谱。\n");
exportgraphics(gcf(), "../fig/BPSK-freq.jpg");

%% 1 生成的信号。
fprintf('## 1 生成的信号\n\n')
raw = generate_signal(1000, 0.3);
fprintf('平均值是 %.3f ≈ 0.3，符合预期。\n', mean(raw));
fprintf('开头符号如下。\n');
raw(1:20)

figure('Name', '各序列、波形开头');
subplot(3, 1, 1);
stem(raw(1:20));
title(join(["信源序列：" string(raw(1:20))]));
xlabel('$n$ / symbol', 'Interpreter', 'latex');
ylabel('信源');
ylim([-0.2 1.2]);
% 这里画序列，而后面画波形，二者默认长度不完全相同。
xlim([1 21]);
grid 'on';


%% 2 AMI
fprintf('## 2 AMI\n\n')
ami_seq = ami(raw);
fprintf('AMI 开头符号如下。\n');
ami_seq(1:20)

subplot(3, 1, 2);
ami_wave = rz(ami_seq, 8);
plot(ami_wave(1: 8*20));
xlabel('$t$ / sample', 'Interpreter', 'latex');
ylabel('AMI');
ylim([-1.2 1.2]);
grid 'on';


%% 3 HDB3
fprintf('## 3 HDB\n\n')
hdb_seq = hdb(raw, 3);
fprintf('HDB3 开头符号如下。\n');
hdb_seq(1:20)

subplot(3, 1, 3);
hdb_wave = rz(hdb_seq, 8);
plot(hdb_wave(1: 8*20));
xlabel('$t$ / sample', 'Interpreter', 'latex');
ylabel('HDB3');
ylim([-1.2 1.2]);
grid 'on';

exportgraphics(gcf(), '../fig/time.jpg');
fprintf('请看各个序列、波形开头。\n\n');


%% 4 功率谱
fprintf('## 4 功率谱\n\n');

figure('Name', 'AMI 功率谱');
periodogram(ami_wave);
title('AMI 功率谱');
exportgraphics(gcf(), '../fig/AMI-freq.jpg');

figure('Name', 'HDB3 功率谱');
periodogram(hdb_wave);
title('HDB3 功率谱');
exportgraphics(gcf(), '../fig/HDB-freq.jpg');


%% 5 改变信源
fprintf('## 5 改变信源\n\n');
main_5
main_5_smooth

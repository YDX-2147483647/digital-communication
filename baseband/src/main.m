%% 1 生成的信号。
fprintf('## 1 生成的信号\n\n')
raw = generate_signal(1000, 0.3);
fprintf('平均值是 %.3f ≈ 0.3，符合预期。\n', mean(raw));
fprintf('开头符号如下。\n');
raw(1:20)

%% 2 AMI
fprintf('## 2 AMI\n\n')
ami_seq = ami(raw);
fprintf('AMI 开头符号如下。\n');
ami_seq(1:20)

ami_wave = rz(ami_seq, 8);
fprintf('请看归零波形开头。\n');
plot(ami_wave(1: 8*20));
title(join(["信源序列：" string(raw(1:20))]));
xlabel('$t$', 'Interpreter', 'latex');
ylabel('AMI');
ylim([-1.2 1.2]);
grid 'on';

%% 数字序列
fprintf("## 数字序列\n\n");

raw = generate_signal(100, 0.5);
fprintf("信源序列：%s, …\n\n", join(string(raw(1:10)), ", "));

raw_diff = diff_code(raw);
fprintf("差分序列：%s, …\n\n", join(string(raw(1:10)), ", "));


%% 调制
fprintf("## 调制\n\n");
modulated = bpsk(raw_diff, 10, 100 / 10);

% 绘图 DPSK
figure("Name", "序列、波形开头");

subplot(3, 1, 1);
stem(raw(1: 9));
title("信源序列");
xlabel("码元序号");
ylim([-0.2 1.2]);
% 这里画序列，而后面画波形，二者默认长度不完全相同。
% 还要空出首个码元。
xlim([0 10]);

subplot(3, 1, 2);
stem(raw_diff(1: 10));
title("差分序列");
xlabel("码元序号");
ylim([-0.2 1.2]);
xlim([1 11]);

subplot(3, 1, 3);
plot(modulated(1: 100 * 10));
xlabel("样本序号");
ylabel("$s_\mathrm{DPSK}(t)$", "Interpreter", "latex");
title("调制波形");

fprintf("请看序列、波形开头。\n\n");
exportgraphics(gcf(), "../fig/DPSK.jpg");


%% 解调
fprintf("## 解调\n\n");
figure("Name", "解调", "WindowState", "maximized");

%% 解调：a
% 没有噪声，带通滤波器我就省略了。
a = modulated;

subplot(4, 1, 1);
plot(a(1: 100 * 10));
xlabel("样本序号");
title("a");

%% 解调：b
b = [zeros(1, 100) modulated(1: end-100)];

subplot(4, 1, 2);
plot(a(1: 100 * 10));
xlabel("样本序号");
title("b");

%% 解调：c
c = a .* b;

subplot(4, 1, 3);
plot(c(1: 100 * 10));
xlabel("样本序号");
title("c");

%% 解调：d
d = simple_filter(c, ones(1, 10));

subplot(4, 1, 4);
plot(d(1: 100 * 10));
xlabel("样本序号");
title("d");
ylim(1.2 * minmax(d));

%% 解调：保存
fprintf("请看各点波形开头。\n\n");
exportgraphics(gcf(), "../fig/DPSK-demodulate.jpg");


%% 抽样判决
fprintf("## 抽样判决\n\n");
r = 1 - judge_bipolar(d(101: end), 100);

% 绘图 judge
figure("Name", "抽样判决");
stem(r(1: 9));
title("判决结果");
xlabel("码元序号");
ylim([-0.2 1.2]);
xlim([0 10]);

fprintf("请看抽样判决结果。\n\n")
exportgraphics(gcf(), "../fig/DPSK-judge.jpg");

if isequal(r, raw)
    fprintf("译码全部正确。\n")
else
    fprintf("译码错了 %d 位。\n", sum(abs(r - raw)));
end

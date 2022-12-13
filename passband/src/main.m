%% 1 生成的信号
fprintf("## 1 生成的信号\n\n");
raw = generate_signal(100, 0.5);
fprintf("信源序列：%s, …\n\n", join(string(raw(1:10)), ", "));


%% 2 调制
fprintf("## 2 调制\n\n");
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
ylabel("$s_\mathrm{BPSK}(t)$", "Interpreter", "latex");
title("调制波形");

fprintf("请看序列、波形开头。\n");
exportgraphics(gcf(), "../fig/BPSK.jpg");

% 绘图 BPSK-freq
figure("Name", "功率谱");
periodogram(modulated);
title("调制波形的功率谱");

fprintf("请看功率谱。\n\n");
exportgraphics(gcf(), "../fig/BPSK-freq.jpg");


%% 3 正常解调
fprintf("## 3 正常解调\n\n");
x_normal = interfere(modulated, 100 / 10);

y_normal = simple_filter(x_normal, ones(1, 10));
r_normal = judge_bipolar(y_normal, 100);

y_long = simple_filter(x_normal, ones(1, 12));
r_long = judge_bipolar(y_long, 100);

% 绘图 demodulate-normal
figure("Name", "正常解调", "WindowState", "maximized");

tiledlayout(3, 2);

nexttile([1 2]);
plot(x_normal(1: 100 * 10));
xlabel("样本序号");
ylabel("$x(t)$", "Interpreter", "latex");
title("相干后波形");

for i = 3:4
    nexttile
    if i == 3
        y = y_normal;
        tail = "正常响应";
    else
        y = y_long;
        tail = "长响应";
    end

    plot(y(1: 100 * 10));
    title(sprintf("滤波后波形（%s）", tail));
    xlabel("样本序号");
    ylabel("$y(t)$", "Interpreter", "latex");
    ylim(1.2 * minmax(y));
end

for i = 5:6
    nexttile
    if i == 5
        r = r_normal;
        tail = "正常响应";
    else
        r = r_long;
        tail = "长响应";
    end

    stem(r_normal(1: 10));
    title(sprintf("判决结果（%s）", tail));
    xlabel("码元序号");
    ylim([-0.2 1.2]);
    xlim([0.5 10.5]);
end

fprintf("请看正常解调情况。\n\n");
exportgraphics(gcf(), "../fig/demodulate-normal.jpg");


%% 4 反相工作
fprintf("## 4 反相工作\n\n");
x_inverse = interfere(modulated, 100 / 10, "InitialPhase", pi);
y_inverse = simple_filter(x_inverse, ones(1, 10));
r_inverse = judge_bipolar(y_inverse, 100);

% 绘图 demodulate-inverse
figure("Name", "反相工作", "WindowState", "maximized");

subplot(3,1,1);
plot(x_inverse(1: 100 * 10));
xlabel("样本序号");
ylabel("$x(t)$", "Interpreter", "latex");
title("相干后波形");

subplot(3,1,2);
plot(y_inverse(1: 100 * 10));
title("滤波后波形");
xlabel("样本序号");
ylabel("$y(t)$", "Interpreter", "latex");
ylim(1.2 * minmax(y_inverse));

subplot(3,1,3);
stem(r_inverse(1: 10));
title("判决结果");
xlabel("码元序号");
ylim([-0.2 1.2]);
xlim([0.5 10.5]);

fprintf("请看反相工作时情况。\n\n");
exportgraphics(gcf(), "../fig/demodulate-inverse.jpg");


%% 5 不同步
fprintf("## 5 不同步\n\n");
x_async = interfere(modulated, 100 / 10.05);
y_async = simple_filter(x_async, ones(1, 10));
r_async = judge_bipolar(y_async, 100);

% 绘图 demodulate-async
figure("Name", "不同步", "WindowState", "maximized");

subplot(3,1,1);
plot(x_async(1: 100 * 10));
xlabel("样本序号");
ylabel("$x(t)$", "Interpreter", "latex");
title("相干后波形");

subplot(3,1,2);
plot(y_async(1: 100 * 10));
title("滤波后波形");
xlabel("样本序号");
ylabel("$y(t)$", "Interpreter", "latex");
ylim(1.2 * minmax(y_async));

subplot(3,1,3);
stem(r_async(1: 10));
title("判决结果");
xlabel("码元序号");
ylim([-0.2 1.2]);
xlim([0.5 10.5]);

fprintf("请看不同步时情况。\n");
exportgraphics(gcf(), "../fig/demodulate-async.jpg");

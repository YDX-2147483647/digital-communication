# 一、数字基带传输系统仿真

## 1 简介

### 背景知识

- **基带信号**是频谱分布在零频或低频附近，未经调制的信号。
- 为了匹配信道传输特性，基带信号传输前一般要**变换**码型、波形等，修正信号特性。
- **数字**基带信号表示为消息代码的电波形。无直流分量有利于在信道传输，定时信息有利于接收端同步。从功率谱可分析定时信息。

### 目标

1. 掌握数字基带传输系统基本知识。
2. 熟悉Matlab环境并编写函数实现功能。
3. 熟悉实验报告的规范写作方法。

## 2 基本原理和算法

### 波形

<figure>
    <img src="baseband.assets/Digital_signal_encoding_formats-en.svg">
    <figcaption>数字基带信号的各种二进制波形｜<a href='https://commons.wikimedia.org/wiki/File:Digital_signal_encoding_formats-en.svg'>Wikimedia Commons</a></figcaption>
</figure>

- **不归零**和**归零**

  按脉冲宽度是否占据整个码元宽度，波形可分为不归零（non-return-to-zero，NRZ）、归零（return-to-zero，RZ），占据比例称作占空比。

- **单极性**和**双极性**

  电平只取正值或零的称作单极性（上图除 Bipolar 以外的所有波形），电平可正可负的称作双极性（bipolar）。

  双极性波形可以让直流分量是零，有利于在信道传输。同时它可以让判决电平是零，与信号幅度无关，让译码更稳定。

- **绝对**与**相对**

  只有当前码元决定的是绝对，当前码元相对前一码元决定的是相对。相对码又称差分（differential）码，如上图 Differential manchester。

  相对码排除了初始状态对波形的影响，接收端译码时没有歧义。

### 功率谱

数字基带信号的功率谱离散（Dirac δ）、连续（普通函数）两部分。离散谱由稳态分量决定，影响直流、定时；连续谱由交变分量决定，影响带宽。

若假设所有码元及其波形相互独立，可用信源分布、每种码元的波形解析表示出功率谱密度；然而本项目涉及的码全都不满足条件，故不再赘述。

### 具体编码

- **AMI**（Alternative Mark Inversion）

  0发0，1交替发 ±1。

  无论信源怎样分布，都保证没有直流。

- **HDB**（High Density Bipolar）

  为保证定时分量，需避免连续零。

  连续0 → `00…0V` / `B0…0V`。（保证编码后连零数量不超过 order，order 实用时常取 3）

  - V (Violation) 同时满足两个条件：
    - （V之间）交替 ±1 ——保证平均仍是零。
    - 极性与前一号相同（“前一号”包括原有1和新加的V、B）——方便译码。
  - V 的两个条件可能矛盾，于是要引入 B (Balance)。

## 3 编程实现

### 生成数字基带信号`generate_signal.m`

返回一个长为 n 的信号，码元只有0、1，其中1的概率为p。（即 Bernoulli 分布）

1. 先在 $(0,1)$ 生成均匀分布的随机数。
2. 取值小于`p`的作为 1，其它作为 0。
3. 将 logical 数组转换为 numbers。

实际代码如下。其中 arguments 块验证数据类型，不影响程序逻辑，所以我们下面都省略。注释已涵盖在正文，我也不再重复，读者您可阅读附件中源代码或用`help <我的函数名>`查看。

```matlab
function signal = generate_signal(n, p)
%generate_signal - 生成二进制随机信号
%
% signal = generate_signal(n, p) 返回一个长为 n 的信号，码元只有0、1，其中1的概率为p。（即 Bernoulli 分布）
arguments
    n(1,1) {mustBePositive, mustBeInteger}
    p(1,1) {mustBePositive, mustBeNumeric, mustBeLessThanOrEqual(p,1)}
end

signal = rand(1, n) < p;

% logical → numbers
signal = 1 * signal;

end
```

### AMI 编码`ami.m`

输入原始码`x`，输出 AMI 码。注意输出仍是数字信号，不涉及具体波形，下同。

如果码中包含 1，那么 AMI 编码有多种选择：将所有 ±1 对调，仍是合理且同义的 AMI 码。为此我设计了`first_mark`参数来限定。

```mermaid
flowchart TB
    copy["直接抄下原始码型<br>y = x"]
    --> init["next_mark = first_mark"]
    --> for

    subgraph for["按时间遍历 i"]
        if{"x(i)"} -->|1| set["y(i) = next_mark"]
        --> flip["翻转 next_mark"]
        
        if -->|0| 继续
    end
```

### HDB 编码`hdb.m`

输入原始码`x`、最大允许连零个数`order`，输出 HDB 码。

序列较长时，HDB 编码总有多种选择，我也设计了一些参数来限定，如下。

- `FirstMark`：首个“1”的编码，取 ±1。

  编码后将所有 ±1 对调，码仍然有效且同义。

- `FirstViolation`：首个V的选取方法，±1 人为指定，0 不限制。

  V 的两个条件都涉及“上一个 V”或“上一个 1”，而序列开头它们可能不存在，这就有了自由度。

HDB 需在 AMI 基础上添加 V、B。

- AMI 基础——`last_mark`。
- 连续0 → `00…0V` / `B0…0V` ——我们用`n_zeros`记录连续零的个数。
- V (Violation) 同时满足两个条件：
  - 交替 ±1 ——我们用`last_v`记录上一个 V。
  - 极性与前一号相同——沿用`last_mark`，这个变量兼顾普通 1 和 V、B。
- V 的两个条件可能矛盾，于是要引入 B (Balance) ——添加 V 时检查，若矛盾，退回去添加 B。

```mermaid
flowchart TB
准备工作 --> for

subgraph 准备工作
    direction TB
    zeros["开辟数组<br>y = zeros(size(x))"]
        初始化["初始化<br>last_mark = - FirstMark<br>last_v = - FirstViolation<br>n_zeros = 0"]
end

subgraph for["按时间遍历 i"]
    direction TB
    count --> encode
    
    subgraph count["数零"]
        if_count{"x(i)"} -->|1| reset["打断计数<br>n_zeros = 0"]
        if_count -->|0| increment["计数<br>n_zeros += 1"]
    end
    
    subgraph encode["编码"]
        if{"x(i)"} -->|1| ami["按 AMI 编码<br>y(i) = - last_mark;<br>last_mark = y(i); "]

        if
        -->|0| elseif{"n_zeros > order"}
        -->|"✗"| 忽略["尚未形成连续零，<br>忽略，继续"]
        
        elseif
        -->|"✓"| check{"存在矛盾？<br>last_mark == last_v"}
        -->|"✓"| balance["添加 B<br>first_zero = i + 1 - n_zeros;<br>y(first_zero) = - last_v;<br>last_mark = y(first_zero);"]:::crit
        --> violation
        
        check
        -->|"✗"| violation["添加 V<br>y(i) = last_mark;<br>last_mark = last_v = y(i);"]:::crit
        --> reset_2["重置计数器<br>n_zeros = 0"]
    end
end

classDef crit fill:orange
```

### 生成归零波形`rz.m`

输入数字序列里`x`、采样率`f`，输出波形`y`。

每个码元的波形为矩形，占空比可用`DutyRatio`指定。

1. 制备每个码元的波形。

   ```matlab
   n_nonzeros = round(f * options.DutyRatio);
   n_zeros = f - n_nonzeros;
   % 每个码元的波形就是 [ones(1, n_nonzeros) zeros(1, n_zeros)]
   ```

2. 按每个码元的波形分组，先构造矩阵。`y_mat`的维度依次是慢时间（码元序号）、快时间（当前码元中的采样序号）。

   ```matlab
   y_mat = x' * [ones(1, n_nonzeros) zeros(1, n_zeros)];
   ```

3. 压平。

   ```matlab
   y = reshape(y_mat.', 1, []);
   ```

### 测试`○○_test.m`

> 这些单元测试是和以上模块同时写的，只是单独列出来。

单元测试我采用基于脚本的测试框架。例如`rz_test.m`测试`rz`，如下。

```matlab
signal = [0 1 -1 0];
n = length(signal);

% ……

%% Double rate, half duty
assert(isequal( ...
    rz(signal, 2, 'DutyRatio', 0.5), ...
    [0 0 1 0 -1 0 0 0] ...
));
```

这些测试除了验证功能（如下面第一段），还帮助我发现了 AMI、HDB 的歧义（如下面第二段），并最终明确下来（如下面第三段，同样给四个零编码，HDB-3 有多种选择）。

```matlab
%% Consecutive zeros
assert(isequal(hdb([0 0 0], 3), [0 0 0]));
assert(isequal(hdb([0 0 0 0], 3), [0 0 0 +1]));
assert(isequal(hdb([0 0 0 0], 4), [0 0 0 0]));
```

```matlab
%% The example on slide (§6.2.2.1, page 39)
assert(isequal( ...
    hdb([1 0 0 0 0 1 0 0 0 0 1 1 0 0 0 0 0 0 0 0 1 1], 3), ...
    [-1 0 0 0 -1 1 0 0 0 +1 -1 +1 -1 0 0 -1 +1 0 0 +1 -1 +1] ...
));
```

```matlab
%% Set first violation and first mark
assert(isequal( ...
    hdb([0 0 0 0], 3, 'FirstMark', -1, 'FirstViolation', -1), ...
    [-1 0 0 -1] ...
));
assert(isequal( ...
    hdb([0 0 0 0], 3, 'FirstMark', -1, 'FirstViolation', +1), ...
    [0 0 0 +1] ...
));
% ……
assert(isequal( ...
    hdb([0 0 0 0], 3, 'FirstMark', +1, 'FirstViolation', -1), ...
    [0 0 0 -1] ...
));
% ……
```

### 主函数`main.m`等

> 其实并不能叫主“函数”——`main.m`会打印文字、输出图片，高度特化于实验要求，我没有写成函数。

虽说要随机生成码元，但只显示开头，不一定碰到连续零，可能展示不出 HDB-3。因此我指定了随机数种子。

```matlab
rng(44); % 保证碰到连续零，以展示 HDB-3
```

#### 1 生成的信号

调用刚才的函数即可。

```matlab
fprintf('## 1 生成的信号\n\n')
raw = generate_signal(1000, 0.3);
fprintf('平均值是 %.3f ≈ 0.3，符合预期。\n', mean(raw));
fprintf('开头符号如下。\n');
raw(1:20)
```

然后画图。画图代码比较繁琐，意义不大，后面不再完整罗列，请直接参考附件源代码。

```matlab
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
```

这里只画前 20 点，横坐标范围是1, …, 20，却设置`xlim([1 21])`，是因为下面波形的横坐标范围是 $[1,2),\, [2, 3), \ldots, [20, 21)$，总共 $[0, 21)$，多留个空白方便对齐。

#### 2 AMI

直接调用即可。

```matlab
fprintf('## 2 AMI\n\n')
ami_seq = ami(raw);
fprintf('AMI 开头符号如下。\n');
ami_seq(1:20)

subplot(3, 1, 2);
ami_wave = rz(ami_seq, 8);
plot(ami_wave(1: 8*20));
% ……（画图）……
```

采样率是码率的 8 倍，故`ami_wave = rz(ami_seq, 8)`。画图只画前 20 个码元，对应前 8×20 个采样点。

#### 3 HDB

同 AMI。

```matlab
fprintf('## 3 HDB\n\n')
hdb_seq = hdb(raw, 3);
fprintf('HDB3 开头符号如下。\n');
hdb_seq(1:20)

subplot(3, 1, 3);
hdb_wave = rz(hdb_seq, 8);
plot(hdb_wave(1: 8*20));
% ……（画图）……

exportgraphics(gcf(), '../fig/time.jpg');
fprintf('请看各个序列、波形开头。\n\n');
```

#### 4 功率谱

我们使用`periodogram`计算、绘制功率谱。这样出来的横坐标是数字频率，而我们其实关心模拟频率，二者不同，我会在分析时进一步解释。

```matlab
fprintf('## 4 功率谱\n\n');

% ……（画图）……
periodogram(ami_wave);
% ……（画图）……
periodogram(hdb_wave);
% ……（画图）……
```

#### 几种展示功率谱的方法`misc_periodogram.m`

因为数据只有有限长，上面画出来全是毛刺，看不清。我尝试了其它方法。

- **单次原始**：即上面的方法。
- **单次滑动平均**：像上面一样计算出功率谱，然后对频率滑动平均这个功率谱密度，当作实际的功率谱密度。
- **多次平均**：重复很多次实验，像上面一样计算出每一次的功率谱（因为信号随机，每次结果不完全相同），然后相同频率上每次的功率谱密度做平均，合并成一张功率谱作为实际的功率谱密度。

这些方法的意义、效果等到后面再分析，这里只介绍编程实现。

```matlab
l = 10000; % 数字序列长
p = 0.3; % 1 的概率
n = 10; % 重复次数
```

1. 连续生成很多次（`n`次）波形，`reshape`为`wave_set`，其维度依次为时间、实验序号。

   ```matlab
   %% 生成一系列原始功率谱
   raw_set = generate_signal(n * l, p);
   wave_set = rz(ami(raw_set), 8);
   wave_set = reshape(wave_set, [], n);
   ```

2. 用`periodogram`计算所有实验的功率谱密度`pxx_set`，其维度依次为频率、实验序号。

   ```matlab
   [pxx_set, w] = periodogram(wave_set);
   ```

3. 按三种方法分别处理。

   ```matlab
   %% 处理
   powers = [ ...
       pxx_set(:,1) ...
       movmean(pxx_set(:, 1), 10) ...
       mean(pxx_set, 2) ...
   ];
   labels = ["单次原始" "单次滑动平均" "多次平均"];
   ```

   - **单次原始**：挑出第一次实验的数据，直接作为功率谱密度。
   - **单次滑动平均**：挑出第一次实验的数据，对它应用长 10 的滑动平均，作为功率谱密度。
   - **多次平均**：使用所有实验数据，在第二个维度（实验序号）应用平均，作为功率谱密度。

4. 画图。

#### 5 改变信源`main_5.m`等

遍历不同的`p`，画在一起即可。

```matlab
% 零的概率
prob = [1e-2, .1: .2: .9, 1 - 1e-2];

% ……（画图）……
hold on;

for p = 1 - prob
    raw = generate_signal(1000, p);
    ami_seq = ami(raw);
    ami_wave = rz(ami_seq, 8);
    [pxx, w] = periodogram(ami_wave);
    plot(w / pi, 10 * log10(pxx));
end

% ……（画图）……
```

以上按“单次原始”，我后来改成了“多次平均”，需重复实验并平均。

```matlab
% 零的概率
prob = [1e-2, .1: .2: .9, 1 - 1e-2];
l = 10000; % 数字序列长
n = 10; % 重复次数


% ……（画图）……
hold on;

for p = 1 - prob
    raw_set = generate_signal(n * l, p);
    wave_set = rz(ami(raw_set), 8);
    wave_set = reshape(wave_set, [], n);

    [pxx_set, w] = periodogram(wave_set);
    pxx = mean(pxx_set, 2);

    plot(w / pi, 10 * log10(pxx));
end

% ……（画图）……
```

## 4 仿真结果和分析

对齐

模拟频率

多种功率

### 测试

## 5 结论

## 6 参考文献
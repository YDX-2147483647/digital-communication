# 二、数字带通传输系统仿真

## 1 简介

### 背景知识

- **数字调制**指解调器把数字基带信号转换为数字带通信号（已调信号）的过程。
- 利用载波相位变化传递信息的方式称作**相移键控**（phase shift keying，PSK）。由于这种体制相位有歧义，又发展出**差分相移键控**（differential PSK，DPSK）。
- 大部分数字调制体制都可采用**相干解调**，这种方法要求接收端恢复出载波。

### 目标

1. 掌握数字带通传输系统的基本知识。
2. 熟悉Matlab环境并编写函数实现功能。
3. 熟悉实验报告的规范写作方法。

## 2 基本原理和算法

### 数字调制

为使信号匹配信道特性，需数字调制。若信号参量可能取值只有两种，则是二进制体制。

BPSK（binary phase shift keying，aka. 2PSK）用载波的相位传递信息。
$$
\begin{aligned}
\text{signal} &= A \cos(\omega_\text{carrier} t + \varphi_n), \\
\varphi_n &= \begin{cases}
    0 & a_n = 0. \\
    \pi & a_n = 1. \\
\end{cases}
\end{aligned}
$$

> 实际信源符号 $a_n$ 与相位 $\varphi_n$ 不一定如此映射。
>
> $n\in\Z$，$t\in\R$。
>
> 以上方式也可表达为 $\pm A \cos(\omega_c t)$。

此外，PSK 用载波相位的绝对数值表示信息，而接收端恢复的载波不能保证和发送端相位一致，存在歧义，接收机可能反相工作。为此可改用 DPSK（differential PSK），如下。
$$
\begin{aligned}
\varphi_n &= \sum \Delta\varphi_n, \\
\Delta\varphi_n &= \begin{cases}
    0 & a_n = 0. \\
    \pi & a_n = 1. \\
\end{cases}
\end{aligned}
$$

> 实际 $a_n \mapsto \Delta\varphi_n$ 不一定如此映射。

DPSK 也可先变换码型，再套用 PSK 的方法。

### 相干解调

相干解调如下图。

```mermaid
flowchart LR
    in([接收信号])
    --> 带通滤波["带通滤波<br>（只保留载频附近）"]
    --> 相干:::crit
    --> 低通滤波:::crit
    --> 抽样判决
    --> out([输出])
    
    carrier([载波]):::crit -.-> 相干
    clock([定时脉冲]) -.-> 抽样判决

    classDef crit fill:orange;
```

对于 DPSK，要么输出前变换码型，要么改用差分相干解调——不再与载波相乘，而与延时一个码元的接收信号相乘。

> 这相当于自相干。不过一般“相干解调”是信号与载波相干，“差分相干解调”与此不同。

### 采样

带通系统本涉及连续波形，而计算机只有抽样后才能表示，抽样后时间只取采样周期的整倍数。

本项目规定记号如下。

| 下标 |        意义         | 解释 |
| :--: | :-----------------: | :--: |
| $c$  |       carrier       | 载波 |
| $B$  | baud (Émile Baudot) |  码  |
| $s$  |      sampling       | 采样 |

例如，载波与 $\cos(\omega_c t)$ 成正比，码率是 $R_B$（baud/s）或 $f_B$（Hz），采样周期是 $T_s$。

## 3 编程实现

### 生成数字基带信号`generate_signal.m`

> 此部分与前一项目完全相同。

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

### BPSK 调制`bpsk.m`

输入原始码`s`和码率 $f_B$、载频 $f_c$、采样率 $f_s$ 的比例关系，输出波形`x`。

因为本项目不涉及绝对时间（具体是多少 Hz 多少 s），只关心相对时间，即 $f_B:f_c:f_s$ 这种比例。确定三个量需两个比，我采用了如下组合。

- `periods_per_symbol`: $f_c / f_B$.
- `samples_per_period`: $f_s / f_c$.

另外，可以用`InitialPhase`规定载波初相，实现翻转整个信号。

1. 生成单个码元的载波。

   下面的`t`是旋转周数，等于 $f_c$ × 实际时间 $t$，无量纲。每个码元持续 $T_B$，对应无量纲旋转周数是 $f_c T_B = f_c/f_B$，即`periods_per_symbol`。采样周期 $T_s$，对应无量纲旋转周数是 $f_c T_s = 1 / \qty(f_s / f_c)$，即`1/samples_per_period`。

   载波 $\cos(\omega_c t + \varphi_0) = \cos(2\pi \times \qty(f_c t) + \varphi_0)$。

   ```matlab
   t = 0: 1/samples_per_period: periods_per_symbol;
   t = t(1: end-1);  % drop the last
   carrier = cos(2 * pi * t + options.InitialPhase);
   ```

   > `left: step: right`表示左闭右也闭区间，直接使用会导致下一周期的第一点和这一周期的最后一点重复。因此要丢弃末点，改成左闭右开。

2. 生成波形。

   先转换为双极性信号`2*s - 1`，再与载波相乘，得一矩阵，其维度以此为快时间（码元内时间）、慢时间（码元序号）。然后压平。

   ```matlab
   % s → x: 1 → carrier, 0 → -carrier.
   x = carrier.' * (2*s - 1);
   % flatten
   x = reshape(x, 1, []);
   ```

### 相干`interfere.m`

### 简易滤波器`simple_filter.m`

### 抽样判决`judge_bipolar.m`

### 差分编码`diff_code.m`

### 测试`○○_test.m`

### 主函数`main.m`等

## 4 仿真结果和分析

## 5 结论

## 6 参考文献

1. 曹丽娜,樊昌信. 通信原理 第7版[M]. 北京市: 国防工业出版社, 2022.

---

本项目的代码、文档等存档于[仓库 digital-communication](https://github.com/YDX-2147483647/digital-communication)。不少内容和同学讨论过，万一引发著作权纠纷，请参考我每部分的[提交记录及日期](https://github.com/YDX-2147483647/digital-communication/commits/main)。
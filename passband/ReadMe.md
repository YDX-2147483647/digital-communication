# 数字带通传输系统

```matlab
>> cd src
>> runtests  % 测试

>> main  % 运行 PSK 部分
>> close all  % 关闭所有图窗
>> main_dpsk  % 运行 DPSK 部分
```

- 程序入口
  - `main.m`、`main_dpsk.m`：实验内容。

    DPSK 部分单独成文，单独运行。

- 模块
  - `generate_signal.m`、`generate_signal_test.m`：生成数字基带信号。
  - `bpsk.m`、`bpsk_test.m`：BPSK 调制。
  - `interfere.m`、`interfere_test.m`：相干。
  - `simple_filter.m`：简易滤波器。
  - `judge_bipolar.m`、`judge_bipolar_test.m`：抽样判决。
  - `diff_code.m`、`diff_code_test.m`：差分编码。

## 参考

- [Phase-shift keying - Wikipedia](https://en.wikipedia.org/wiki/Phase_shift_keying)
- [Wave interference - Wikipedia](https://en.wikipedia.org/wiki/Wave_interference)
- [Coherence (physics) - Wikipedia](https://en.wikipedia.org/wiki/Coherence_(physics))
- [控制图窗窗口的外观和行为 - MATLAB - MathWorks 中国](https://ww2.mathworks.cn/help/releases/R2020b/matlab/ref/matlab.ui.figure-properties.html)
- [创建分块图布局 - MATLAB tiledlayout - MathWorks 中国](https://ww2.mathworks.cn/help/releases/R2020b/matlab/ref/tiledlayout.html)
- [Differential coding - Wikipedia](https://en.wikipedia.org/wiki/Differential_coding#Other_techniques_to_resolve_a_phase_ambiguity)
- [Cumulative Sum in MATLAB - Geeks for Geeks](https://www.geeksforgeeks.org/cumulative-sum-in-matlab/)
- [累积和 - MATLAB cumsum - MathWorks 中国](https://ww2.mathworks.cn/help/matlab/ref/cumsum.html)

# 数字基带传输系统

```matlab
>> cd src
>> main  % 运行
>> runtests  % 测试
```

- 程序入口
  - `main.m`：实验内容。
    
    第5部分功率谱单独成文（`main_5.m`），在`main.m`中调用；`main_5_smooth.m`是平滑后的，也在`main.m`中调用。

  - `misc_periodogram.m`：几种展示功率谱的方法。

- 模块
  - `generate_signal.m`、`generate_signal_test.m`：生成数字基带信号。
  - `ami.m`、`ami_test.m`：AMI 编码。（只编码，不转换为波形，下同）
  - `hdb.m`、`hdb_test.m`：HDB 编码。
  - `rz.m`、`rz_test.m`：生成归零波形。

## 参考

- [随机数生成 - MATLAB & Simulink - MathWorks 中国](https://ww2.mathworks.cn/help/matlab/random-number-generation.html)
- [How to create a random Bernoulli matrix ? - MATLAB Answers - MATLAB Central](https://ww2.mathworks.cn/matlabcentral/answers/247170-how-to-create-a-random-bernoulli-matrix)
- [编写单元测试的方法 - MATLAB & Simulink - MathWorks 中国](https://ww2.mathworks.cn/help/matlab/matlab_prog/ways-to-write-unit-tests.html)
- [How to support default parameter in MATLAB FUNCTION ? - MATLAB Answers - MATLAB Central](https://ww2.mathworks.cn/matlabcentral/answers/217363-how-to-support-default-parameter-in-matlab-function)
- [Bipolar encoding - Wikipedia](https://en.wikipedia.org/wiki/Bipolar_encoding#Alternate_mark_inversion)
- [解析函数输入 - MATLAB & Simulink - MathWorks 中国](https://ww2.mathworks.cn/help/matlab/matlab_prog/parse-function-inputs.html)
- [声明函数参数验证 - MATLAB arguments - MathWorks 中国](https://ww2.mathworks.cn/help/matlab/ref/arguments.html)
- [AMI LINE CODING WITH MATLAB CODE FOR ENCODING AND DECODING - Tutorial Bit](https://tutorialbit.com/communication-engineering/ami-line-coding-with-matlab-code-for-encoding-and-decoding/)
- [Modified AMI code - Wikipedia](https://en.wikipedia.org/wiki/Modified_AMI_code)
- [使用 FFT 获得功率频谱密度估计 - MATLAB & Simulink - MathWorks 中国](https://www.mathworks.com/help/releases/R2020b/signal/ug/power-spectral-density-estimates-using-fft.html)

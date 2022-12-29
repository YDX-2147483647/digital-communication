# 卷积码的编译码与性能分析

```matlab
>> cd src
>> runtests  % 测试
>> main  % 运行
```

- 程序入口
  - `main.m`：实验内容。
- 模块
  - `conv_encode.m`：编码卷积码。
  - `hamming_distance.m`、`hamming_distance_test.m`：Hamming 距离。
  - `get_transition.m`、`get_transition_test.m`：生成转移方阵。
  - `conv_decode.m`：用 Viterbi 算法解码卷积码。
  - `conv_test.m`：卷积码的测试。

## 参考

- [卷积和多项式乘法 - MATLAB conv - MathWorks 中国](https://ww2.mathworks.cn/help/releases/R2020b/matlab/ref/conv.html)
- [二维卷积 - MATLAB conv2 - MathWorks 中国](https://ww2.mathworks.cn/help/releases/R2020b/matlab/ref/conv2.html)
- [数组元素总和 - MATLAB sum - MathWorks 中国](https://ww2.mathworks.cn/help/releases/R2020b/matlab/ref/sum.html)
- [Viterbi algorithm - Wikipedia](https://en.wikipedia.org/wiki/Viterbi_algorithm)
- ~~[Viterbi decoder matlab code | MATLAB source code](https://www.rfwireless-world.com/source-code/MATLAB/viterbi-decoder-matlab-code.html)~~
- [How to create a Matlab module - MATLAB Answers - MATLAB Central](https://ww2.mathworks.cn/matlabcentral/answers/398355-how-to-create-a-matlab-module)
- [包命名空间 - MATLAB & Simulink - MathWorks 中国](https://ww2.mathworks.cn/help/matlab/matlab_oop/scoping-classes-with-packages.html)
- [查找符合条件的数组元素 - MATLAB & Simulink - MathWorks 中国](https://ww2.mathworks.cn/help/matlab/matlab_prog/find-array-elements-that-meet-a-condition.html)
- [multiple digit number in to individual digits - MATLAB Answers - MATLAB Central](https://ww2.mathworks.cn/matlabcentral/answers/142887-multiple-digit-number-in-to-individual-digits)

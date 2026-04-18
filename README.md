# 计算机系统综合设计A - RISC-V CPU 流水线实现

## 项目简介

本项目为《计算机系统综合设计A》课程实验。目标是使用 Verilog 设计并实现一个支持 RV32I 中 37 条指令的 RISC-V 流水线 CPU，并完成仿真与 FPGA 下板运行。实验说明要求使用 ModelSim/iVerilog 进行仿真，并使用 Vivado 下载到 Nexys4 DDR（Xilinx Artix-7）FPGA 开发板运行。

## 实验目标

* 加深对 CPU 各模块工作原理及相互联系的理解
* 学习使用 EDA 技术设计 RISC-V 流水线 CPU
* 获得 CPU 设计、仿真、综合、实现和运行的实践经验
* 了解并实现简单 SoC 系统

## 实验内容

* 使用 Verilog 设计 RISC-V 流水线 CPU
* 支持 RV32I 中规定的 37 条指令
* 对含数据冒险、控制冒险的汇编程序进行仿真
* 使用 Vivado 综合、实现并下载到 FPGA 板运行

## 实验阶段

1. 搭建五级流水线 CPU 框架
2. 添加 I-type 算术逻辑运算指令
3. 添加 R-type 算术逻辑运算指令
4. 添加跳转指令
5. 添加访存指令
6. 用前递技术解决冲突
7. 用冒险检测 + 停顿解决冲突
8. 基准程序设计、测试与 CPU 调试
9. 中断、接口等附加功能

## 开发环境

* 硬件平台：Nexys4 DDR（Xilinx Artix-7）FPGA 开发板
* 设计工具：Xilinx Vivado
* 仿真工具：ModelSim 或 iVerilog + GTKWave
* 辅助工具：RARS / Venus / Python（按实验需要使用）

> 注意：Vivado 安装路径和工程路径不要包含中文字符。

## Vivado 基本流程

1. 新建 RTL Project
2. 选择对应 FPGA 器件型号
3. 添加 CPU 实现文件和 FPGA 相关文件
4. 添加约束文件
5. 在 IP Catalog 中生成指令存储相关 IP，并加载 `.coe` 初始化文件
6. 运行综合（Synthesis）
7. 运行实现（Implementation）
8. 生成比特流（Bitstream）
9. 下载到 FPGA 开发板并测试运行结果

## FPGA 相关注意事项

* 代码中禁止使用 `initial`
* 禁止使用 `casex`、`casez`
* 禁止使用 `#` 表示延迟
* 时钟信号只应出现在 `always @(posedge clock)` 中

## 说明

本 README 根据课程实验说明整理，具体源码文件名、模块划分和测试程序以本仓库实际内容为准。

//////////////////////////////////////////////////////////////////////////////////
// Project      : Sparse-Aware 4x4 Systolic Array Accelerator
// Module Name  : systolic_arr_4x4
//
// Description:
//   Low-power 4x4 systolic array architecture incorporating
//   sparsity-aware computation techniques.
//
//   Features:
//   - Detects sparse (zero-valued) operands.
//   - Avoids unnecessary MAC activity.
//   - Reduces switching activity inside Processing Elements.
//   - Improves dynamic power efficiency.
//   - Maintains functional equivalence with the baseline design.
//
// Low-Power Strategy:
//   - Sparse operands are identified before multiplication.
//   - Computation is bypassed whenever multiplication result
//     is guaranteed to be zero.
//   - Redundant data movement and internal transitions
//     are minimized.
//
// Data Flow:
//   - A operands propagate horizontally.
//   - B operands propagate vertically.
//   - Valid signals travel with the data stream.
//   - Active PEs perform MAC operations only when required.
//
// Author       : Divya Darshan VR
// Qualification: B.E. Electronics and Communication Engineering
// Institution  : College of Engineering Guindy (CEG)
//                Anna University, Chennai
//
// Version      : 1.0
// Date         : June 2026
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module systolic_arr_4x4 #(
parameter DATA_WIDTH = 8,
parameter SUM_WIDTH  = 4*DATA_WIDTH,
parameter LOW_POWER = 1
)(
input clk,
input rst,
input valid_in,

input [DATA_WIDTH-1:0] a0,a1,a2,a3,
input [DATA_WIDTH-1:0] b0,b1,b2,b3,

output [SUM_WIDTH-1:0] pe00_out,
output [SUM_WIDTH-1:0] pe01_out,
output [SUM_WIDTH-1:0] pe02_out,
output [SUM_WIDTH-1:0] pe03_out,

output [SUM_WIDTH-1:0] pe10_out,
output [SUM_WIDTH-1:0] pe11_out,
output [SUM_WIDTH-1:0] pe12_out,
output [SUM_WIDTH-1:0] pe13_out,

output [SUM_WIDTH-1:0] pe20_out,
output [SUM_WIDTH-1:0] pe21_out,
output [SUM_WIDTH-1:0] pe22_out,
output [SUM_WIDTH-1:0] pe23_out,

output [SUM_WIDTH-1:0] pe30_out,
output [SUM_WIDTH-1:0] pe31_out,
output [SUM_WIDTH-1:0] pe32_out,
output [SUM_WIDTH-1:0] pe33_out


);

wire [DATA_WIDTH-1:0] a_bus[0:3][0:3];
wire [DATA_WIDTH-1:0] b_bus[0:3][0:3];

wire valid_bus[0:3][0:3];

// ---------------- ROW 0 ----------------

pe_mac PE00(
.clk(clk), .rst(rst),
.valid_in(valid_in),
.a_in(a0),
.b_in(b0),
.valid_out(valid_bus[0][0]),
.a_out(a_bus[0][0]),
.b_out(b_bus[0][0]),
.sum_out(pe00_out)
);

pe_mac PE01(
.clk(clk), .rst(rst),
.valid_in(valid_bus[0][0]),
.a_in(a_bus[0][0]),
.b_in(b1),
.valid_out(valid_bus[0][1]),
.a_out(a_bus[0][1]),
.b_out(b_bus[0][1]),
.sum_out(pe01_out)
);

pe_mac PE02(
.clk(clk), .rst(rst),
.valid_in(valid_bus[0][1]),
.a_in(a_bus[0][1]),
.b_in(b2),
.valid_out(valid_bus[0][2]),
.a_out(a_bus[0][2]),
.b_out(b_bus[0][2]),
.sum_out(pe02_out)
);

pe_mac PE03(
.clk(clk), .rst(rst),
.valid_in(valid_bus[0][2]),
.a_in(a_bus[0][2]),
.b_in(b3),
.valid_out(valid_bus[0][3]),
.a_out(),
.b_out(b_bus[0][3]),
.sum_out(pe03_out)
);

// ---------------- ROW 1 ----------------

pe_mac PE10(
.clk(clk), .rst(rst),
.valid_in(valid_bus[0][0]),
.a_in(a1),
.b_in(b_bus[0][0]),
.valid_out(valid_bus[1][0]),
.a_out(a_bus[1][0]),
.b_out(b_bus[1][0]),
.sum_out(pe10_out)
);

pe_mac PE11(
.clk(clk), .rst(rst),
.valid_in(valid_bus[1][0]),
.a_in(a_bus[1][0]),
.b_in(b_bus[0][1]),
.valid_out(valid_bus[1][1]),
.a_out(a_bus[1][1]),
.b_out(b_bus[1][1]),
.sum_out(pe11_out)
);

pe_mac PE12(
.clk(clk), .rst(rst),
.valid_in(valid_bus[1][1]),
.a_in(a_bus[1][1]),
.b_in(b_bus[0][2]),
.valid_out(valid_bus[1][2]),
.a_out(a_bus[1][2]),
.b_out(b_bus[1][2]),
.sum_out(pe12_out)
);

pe_mac PE13(
.clk(clk), .rst(rst),
.valid_in(valid_bus[1][2]),
.a_in(a_bus[1][2]),
.b_in(b_bus[0][3]),
.valid_out(valid_bus[1][3]),
.a_out(),
.b_out(b_bus[1][3]),
.sum_out(pe13_out)
);

// ---------------- ROW 2 ----------------

pe_mac PE20(
.clk(clk), .rst(rst),
.valid_in(valid_bus[1][0]),
.a_in(a2),
.b_in(b_bus[1][0]),
.valid_out(valid_bus[2][0]),
.a_out(a_bus[2][0]),
.b_out(b_bus[2][0]),
.sum_out(pe20_out)
);

pe_mac PE21(
.clk(clk), .rst(rst),
.valid_in(valid_bus[2][0]),
.a_in(a_bus[2][0]),
.b_in(b_bus[1][1]),
.valid_out(valid_bus[2][1]),
.a_out(a_bus[2][1]),
.b_out(b_bus[2][1]),
.sum_out(pe21_out)
);

pe_mac PE22(
.clk(clk), .rst(rst),
.valid_in(valid_bus[2][1]),
.a_in(a_bus[2][1]),
.b_in(b_bus[1][2]),
.valid_out(valid_bus[2][2]),
.a_out(a_bus[2][2]),
.b_out(b_bus[2][2]),
.sum_out(pe22_out)
);

pe_mac PE23(
.clk(clk), .rst(rst),
.valid_in(valid_bus[2][2]),
.a_in(a_bus[2][2]),
.b_in(b_bus[1][3]),
.valid_out(valid_bus[2][3]),
.a_out(),
.b_out(b_bus[2][3]),
.sum_out(pe23_out)
);

// ---------------- ROW 3 ----------------

pe_mac PE30(
.clk(clk), .rst(rst),
.valid_in(valid_bus[2][0]),
.a_in(a3),
.b_in(b_bus[2][0]),
.valid_out(valid_bus[3][0]),
.a_out(a_bus[3][0]),
.b_out(b_bus[3][0]),
.sum_out(pe30_out)
);

pe_mac PE31(
.clk(clk), .rst(rst),
.valid_in(valid_bus[3][0]),
.a_in(a_bus[3][0]),
.b_in(b_bus[2][1]),
.valid_out(valid_bus[3][1]),
.a_out(a_bus[3][1]),
.b_out(b_bus[3][1]),
.sum_out(pe31_out)
);

pe_mac PE32(
.clk(clk), .rst(rst),
.valid_in(valid_bus[3][1]),
.a_in(a_bus[3][1]),
.b_in(b_bus[2][2]),
.valid_out(valid_bus[3][2]),
.a_out(a_bus[3][2]),
.b_out(b_bus[3][2]),
.sum_out(pe32_out)
);

pe_mac PE33(
.clk(clk), .rst(rst),
.valid_in(valid_bus[3][2]),
.a_in(a_bus[3][2]),
.b_in(b_bus[2][3]),
.valid_out(valid_bus[3][3]),
.a_out(),
.b_out(),
.sum_out(pe33_out)
);

endmodule



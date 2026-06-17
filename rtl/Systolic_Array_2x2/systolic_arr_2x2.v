`timescale 1ns/1ps

`include "pe_mac.v"
module systolic_arr_2x2 #(
    parameter DATA_WIDTH = 8,
    parameter SUM_WIDTH  = 4*DATA_WIDTH
)(
    input clk,
    input rst,

    input valid_in,

    input [DATA_WIDTH-1:0] a1,
    input [DATA_WIDTH-1:0] a2,

    input [DATA_WIDTH-1:0] b1,
    input [DATA_WIDTH-1:0] b2,

    output valid_out,

    output [SUM_WIDTH-1:0] pe00_out,
    output [SUM_WIDTH-1:0] pe01_out,
    output [SUM_WIDTH-1:0] pe10_out,
    output [SUM_WIDTH-1:0] pe11_out
);

    // Horizontal links
    wire [DATA_WIDTH-1:0] a00_to_01;
    wire [DATA_WIDTH-1:0] a10_to_11;

    // Vertical links
    wire [DATA_WIDTH-1:0] b00_to_10;
    wire [DATA_WIDTH-1:0] b01_to_11;

    wire v00_to_01;
    wire v00_to_10;
    wire v10_to_11;
    wire v01_to_11;

    pe_mac PE00(
    .clk(clk),
    .rst(rst),

    .valid_in(valid_in),

    .a_in(a1),
    .b_in(b1),

    .valid_out(v00_to_01),

    .a_out(a00_to_01),
    .b_out(b00_to_10),

    .sum_out(pe00_out)
);

pe_mac PE01(
    .clk(clk),
    .rst(rst),

    .valid_in(v00_to_01),

    .a_in(a00_to_01),
    .b_in(b2),

    .valid_out(v01_to_11),

    .a_out(),
    .b_out(b01_to_11),

    .sum_out(pe01_out)
);

pe_mac PE10(
    .clk(clk),
    .rst(rst),

    .valid_in(v00_to_01),

    .a_in(a2),
    .b_in(b00_to_10),

    .valid_out(v10_to_11),

    .a_out(a10_to_11),
    .b_out(),

    .sum_out(pe10_out)
);

pe_mac PE11(
    .clk(clk),
    .rst(rst),

    .valid_in(v01_to_11 & v10_to_11),

    .a_in(a10_to_11),
    .b_in(b01_to_11),

    .valid_out(valid_out),

    .a_out(),
    .b_out(),

    .sum_out(pe11_out)
);

endmodule
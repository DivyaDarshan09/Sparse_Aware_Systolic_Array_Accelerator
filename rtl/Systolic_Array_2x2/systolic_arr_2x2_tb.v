`timescale 1ns/1ps

module systolic_arr_2x2_tb;

parameter DATA_WIDTH = 8;
parameter SUM_WIDTH  = 32;

reg clk;
reg rst;

reg [DATA_WIDTH-1:0] a1,a2;
reg [DATA_WIDTH-1:0] b1,b2;

wire [SUM_WIDTH-1:0] pe00_out;
wire [SUM_WIDTH-1:0] pe01_out;
wire [SUM_WIDTH-1:0] pe10_out;
wire [SUM_WIDTH-1:0] pe11_out;

reg valid_in;

systolic_arr_2x2 dut(
    .clk(clk),
    .rst(rst),

    .a1(a1),
    .a2(a2),

    .b1(b1),
    .b2(b2),
    .valid_in(valid_in),
    .valid_out(),

    .pe00_out(pe00_out),
    .pe01_out(pe01_out),
    .pe10_out(pe10_out),
    .pe11_out(pe11_out)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("systolic_2x2.vcd");
    $dumpvars(0,systolic_arr_2x2_tb);
end

initial begin

    clk = 0;
    rst = 1;
    valid_in = 0;
    a1 = 0;
    a2 = 0;
    b1 = 0;
    b2 = 0;

    #12;
    rst = 0;

    //--------------------------------
    // Cycle 1 Inputs
    //--------------------------------
    valid_in = 1;
    a1 = 8'd1;
    a2 = 8'd0;

    b1 = 8'd5;
    b2 = 8'd0;

    #10;

    //--------------------------------
    // Cycle 2 Inputs
    //--------------------------------
    a1 = 8'd2;
    a2 = 8'd3;

    b1 = 8'd7;
    b2 = 8'd6;

    #10;

    //--------------------------------
    // Cycle 3 Inputs
    //--------------------------------
    a1 = 8'd0;
    a2 = 8'd4;

    b1 = 8'd0;
    b2 = 8'd8;

    #10;
    valid_in = 0;

    //--------------------------------
    // Flush pipeline
    //--------------------------------
    a1 = 0;
    a2 = 0;

    b1 = 0;
    b2 = 0;

    #50;

    $finish;
end

always @(posedge clk) begin
    $display(
    "T=%0t | pe00=%0d pe01=%0d pe10=%0d pe11=%0d",
    $time,
    pe00_out,
    pe01_out,
    pe10_out,
    pe11_out
    );
end

endmodule
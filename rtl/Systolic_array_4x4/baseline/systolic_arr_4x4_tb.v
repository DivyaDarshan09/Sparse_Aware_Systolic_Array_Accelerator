`timescale 1ns/1ps

module systolic_arr_4x4_tb;

parameter DATA_WIDTH = 8;
parameter SUM_WIDTH  = 32;
parameter LOW_POWER = 0;
reg clk;
reg rst;
reg valid_in;

reg [DATA_WIDTH-1:0] a0,a1,a2,a3;
reg [DATA_WIDTH-1:0] b0,b1,b2,b3;

wire [SUM_WIDTH-1:0] pe00_out,pe01_out,pe02_out,pe03_out;
wire [SUM_WIDTH-1:0] pe10_out,pe11_out,pe12_out,pe13_out;
wire [SUM_WIDTH-1:0] pe20_out,pe21_out,pe22_out,pe23_out;
wire [SUM_WIDTH-1:0] pe30_out,pe31_out,pe32_out,pe33_out;

systolic_arr_4x4 dut(
    .clk(clk),
    .rst(rst),

    .valid_in(valid_in),

    .a0(a0),
    .a1(a1),
    .a2(a2),
    .a3(a3),

    .b0(b0),
    .b1(b1),
    .b2(b2),
    .b3(b3),

    .pe00_out(pe00_out),
    .pe01_out(pe01_out),
    .pe02_out(pe02_out),
    .pe03_out(pe03_out),

    .pe10_out(pe10_out),
    .pe11_out(pe11_out),
    .pe12_out(pe12_out),
    .pe13_out(pe13_out),

    .pe20_out(pe20_out),
    .pe21_out(pe21_out),
    .pe22_out(pe22_out),
    .pe23_out(pe23_out),

    .pe30_out(pe30_out),
    .pe31_out(pe31_out),
    .pe32_out(pe32_out),
    .pe33_out(pe33_out)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("systolic_4x4.vcd");
    $dumpvars(0,tb);
end

initial begin

    clk = 0;
    rst = 1;
    valid_in = 0;

    a0=0; a1=0; a2=0; a3=0;
    b0=0; b1=0; b2=0; b3=0;

    #12;
    rst = 0;

    //--------------------------------
    // Cycle 1
    //--------------------------------
    valid_in = 1;

    a0 = 1;
    a1 = 5;
    a2 = 0;   // sparse
    a3 = 13;

    b0 = 1;
    b1 = 0;   // sparse
    b2 = 3;
    b3 = 4;

    #10;

    //--------------------------------
    // Cycle 2
    //--------------------------------
    a0 = 2;
    a1 = 6;
    a2 = 10;
    a3 = 0;   // sparse

    b0 = 5;
    b1 = 6;
    b2 = 0;   // sparse
    b3 = 8;

    #10;

    //--------------------------------
    // Cycle 3
    //--------------------------------
    a0 = 3;
    a1 = 0;   // sparse
    a2 = 11;
    a3 = 15;

    b0 = 9;
    b1 = 10;
    b2 = 11;
    b3 = 0;   // sparse

    #10;

    //--------------------------------
    // Cycle 4
    //--------------------------------
    a0 = 4;
    a1 = 8;
    a2 = 12;
    a3 = 16;

    b0 = 13;
    b1 = 14;
    b2 = 15;
    b3 = 16;

    #10;

    //--------------------------------
    // Flush
    //--------------------------------
    valid_in = 0;

    a0=0; a1=0; a2=0; a3=0;
    b0=0; b1=0; b2=0; b3=0;

    #100;


$display("\n====================================");
$display("         ARRAY RESULTS");
$display("====================================");

$display("PE00=%0d PE01=%0d PE02=%0d PE03=%0d",
         pe00_out,pe01_out,pe02_out,pe03_out);

$display("PE10=%0d PE11=%0d PE12=%0d PE13=%0d",
         pe10_out,pe11_out,pe12_out,pe13_out);

$display("PE20=%0d PE21=%0d PE22=%0d PE23=%0d",
         pe20_out,pe21_out,pe22_out,pe23_out);

$display("PE30=%0d PE31=%0d PE32=%0d PE33=%0d",
         pe30_out,pe31_out,pe32_out,pe33_out);

$display("\n====================================");
$display("         MAC STATISTICS");
$display("====================================");

$display("PE00 : Total=%0d Effective=%0d Skipped=%0d",
         dut.PE00.total_macs,
         dut.PE00.effective_macs,
         dut.PE00.total_macs-dut.PE00.effective_macs);

$display("PE11 : Total=%0d Effective=%0d Skipped=%0d",
         dut.PE11.total_macs,
         dut.PE11.effective_macs,
         dut.PE11.total_macs-dut.PE11.effective_macs);

$display("PE22 : Total=%0d Effective=%0d Skipped=%0d",
         dut.PE22.total_macs,
         dut.PE22.effective_macs,
         dut.PE22.total_macs-dut.PE22.effective_macs);

$display("PE33 : Total=%0d Effective=%0d Skipped=%0d",
         dut.PE33.total_macs,
         dut.PE33.effective_macs,
         dut.PE33.total_macs-dut.PE33.effective_macs);

$display("====================================");
    $finish;

end

always @(posedge clk) begin

    $display(
    "T=%0t | PE00=%0d PE11=%0d PE22=%0d PE33=%0d",
    $time,
    pe00_out,
    pe11_out,
    pe22_out,
    pe33_out
    );

end

endmodule


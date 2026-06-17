//////////////////////////////////////////////////////////////////////////////////
// Project      : 2x2 Systolic Array Accelerator
// Module Name  : pe_mac
//
// Description:
//   Baseline Processing Element (PE) used in the 2x2 systolic array.
//
// Features:
//   - Performs Multiply-Accumulate (MAC) operation.
//   - Propagates A operands horizontally.
//   - Propagates B operands vertically.
//   - Executes MAC operation whenever valid data is available.
//   - No sparsity detection or low-power optimization.
//
// Operation:
//      sum_out = sum_out + (a_in * b_in)
//
// Data Movement:
//   - a_out forwards A data to the next PE in the row.
//   - b_out forwards B data to the next PE in the column.
//   - valid_out propagates the validity of incoming data.
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
module pe_mac #(
    parameter DATA_WIDTH = 8,
    parameter SUM_WIDTH  = 4*DATA_WIDTH
)(
    input clk,
    input rst,

    input valid_in,

    input  [DATA_WIDTH-1:0] a_in,
    input  [DATA_WIDTH-1:0] b_in,

    output reg valid_out,

    output reg [DATA_WIDTH-1:0] a_out,
    output reg [DATA_WIDTH-1:0] b_out,

    output reg [SUM_WIDTH-1:0] sum_out
);

always @(posedge clk) begin
    if(rst) begin
        valid_out <= 1'b0;
        a_out     <= '0;
        b_out     <= '0;
        sum_out   <= '0;
    end
    else begin

        // propagate data
        a_out <= a_in;
        b_out <= b_in;

        // propagate valid
        valid_out <= valid_in;

        // MAC only when data is valid
        if(valid_in)
            sum_out <= sum_out + (a_in * b_in);
    end
end

endmodule
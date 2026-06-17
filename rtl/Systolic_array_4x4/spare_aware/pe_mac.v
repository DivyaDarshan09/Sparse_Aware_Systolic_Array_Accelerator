//////////////////////////////////////////////////////////////////////////////////
// Module Name : pe_mac
//
// Description:
//   Sparse-aware Processing Element (PE) for a 4x4 systolic array accelerator.
//
// Features:
//   - Performs Multiply-Accumulate (MAC) operations.
//   - Supports optional low-power mode through operand sparsity detection.
//   - Propagates A operands horizontally.
//   - Propagates B operands vertically.
//   - Tracks MAC utilization statistics.
//
// Low-Power Operation:
//   When LOW_POWER = 1:
//
//      if(a_in == 0 || b_in == 0)
//          MAC operation is skipped.
//
//   This reduces unnecessary switching activity and dynamic power
//   consumption for sparse workloads.
//
// Counters:
//   total_macs
//      Total MAC opportunities received.
//
//   effective_macs
//      Useful MAC operations actually executed.
//
// Author       : Divya Darshan VR
// Qualification: B.E. Electronics and Communication Engineering
// Institution  : College of Engineering Guindy (CEG)
//                Anna University, Chennai
//
// Version      : 1.0
// Date         : June 2026
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ps/1ps
module pe_mac #(
    parameter DATA_WIDTH = 8,
    parameter SUM_WIDTH  = 4*DATA_WIDTH,
    parameter LOW_POWER  = 1
)(
    input clk,
    input rst,

    input valid_in,

    input [DATA_WIDTH-1:0] a_in,
    input [DATA_WIDTH-1:0] b_in,

    output reg valid_out,

    output reg [DATA_WIDTH-1:0] a_out,
    output reg [DATA_WIDTH-1:0] b_out,

    output reg [SUM_WIDTH-1:0] sum_out,

    output reg [31:0] total_macs,
    output reg [31:0] effective_macs
);

always @(posedge clk) begin
    if(rst) begin
        valid_out      <= 1'b0;
        a_out          <= '0;
        b_out          <= '0;
        sum_out        <= '0;
        total_macs     <= '0;
        effective_macs <= '0;
    end
    else begin

        a_out <= a_in;
        b_out <= b_in;

        valid_out <= valid_in;

        if(valid_in) begin

            total_macs <= total_macs + 1;

            if(LOW_POWER) begin

                if((a_in != 0) && (b_in != 0)) begin
                    sum_out <= sum_out + (a_in * b_in);
                    effective_macs <= effective_macs + 1;
                end

            end
            else begin

                sum_out <= sum_out + (a_in * b_in);
                effective_macs <= effective_macs + 1;

            end
        end
    end
end

endmodule
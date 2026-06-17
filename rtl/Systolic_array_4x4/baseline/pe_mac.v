module pe_mac #(
    parameter DATA_WIDTH = 8,
    parameter SUM_WIDTH  = 4*DATA_WIDTH,
    parameter LOW_POWER  = 0
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

            sum_out <= sum_out + (a_in * b_in);

            effective_macs <= effective_macs + 1;

        end

    end

end

endmodule
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
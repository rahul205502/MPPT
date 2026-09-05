
module register #(parameter N=12) (
    input clk, rstn, en,
    input [N-1:0] D_in,
    output [N-1:0] D_out
);

reg [N-1:0] mem;

always @(posedge clk or negedge rstn) begin
    if (!rstn) mem <= 0;
    else if (en) mem <= D_in;
end

assign D_out = mem;

endmodule
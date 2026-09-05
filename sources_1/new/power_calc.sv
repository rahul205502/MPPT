
module power_calc #(parameter N=12) (
    input clk, rstn, en,
    input [N-1:0] v, i,
    output logic [2*N-1:0] p
);

always @(posedge clk or negedge rstn) begin
    if (!rstn) p <= 0;
    else if (en) p <= v * i;
end

endmodule
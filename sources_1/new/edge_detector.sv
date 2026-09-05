
module edge_detector (
    input clk, rstn, q_debounce,
    output q_pulse
);

logic q_prev;

always @(posedge clk or posedge rstn) begin
    if (!rstn) q_prev <= 1'b0;
    else q_prev <= q_debounce;
end

assign q_pulse = q_debounce & ~q_prev;

endmodule
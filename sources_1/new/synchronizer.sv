
module synchronizer (
    input clk, rstn,
    input q,
    output q_sync
);
  
logic q1, q2;

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        q1 <= 1'b0;
        q2 <= 1'b0;
    end
    else begin
        q1 <= q;
        q2 <= q1;
    end
end

assign q_sync = q2;
  
endmodule

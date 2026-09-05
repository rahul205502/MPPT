
module debouncer #(parameter COUNT = 1_000_000) (
    input clk, rstn, q_sync,
    output logic q_debounce
);

logic [19:0] count;

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        q_debounce <= 1'b0;
        count <= 20'd0;
    end
    else begin
        if (q_sync == q_debounce) count <= 20'd0;
        else if (count == COUNT-1) begin
            q_debounce <= q_sync;
            count <= 20'd0;
        end
        else count <= count + 1;
    end
end

endmodule
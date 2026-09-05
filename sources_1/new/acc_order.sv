
module acc_order #(parameter N=12, ORDER=4) (
    input clk, rstn, en, sample,
    input [N-1:0] q,
    output logic [N-1:0] q_avg,
    output logic done
);

logic [N-1+($clog2(ORDER)-1):0] mem;
logic [$clog2(ORDER)-1:0] count;

enum logic [1:0] {IDLE, COUNT, DIV, DONE} state;

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        q_avg <= 0; 
        mem <= 0;
        count <= 0;
        done <= 1'b0;
        state <= IDLE;
    end
    else begin
        done <= 1'b0;
        case (state)
            IDLE: begin
                if (en) begin
//                    q_avg <= 0;
                    mem <= 0;
                    count <= 0;
                    state <= COUNT;
                end
            end
            COUNT: begin
                if (sample) begin
                    mem <= mem + q;
                    if (count == ORDER-1) state <= DIV; 
                    else count <= count + 1;
                end
            end
            DIV: begin
                q_avg <= mem / ORDER;
                state <= DONE;
            end
            DONE: begin
                done <= 1'b1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule
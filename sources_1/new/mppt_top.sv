
module mppt_top #(parameter N=12, t=1, M=16, ORDER=4) (
    input clk, rst_btn, en, rd,
    input [N-1:0] v, i,
    output logic inc_duty, dec_duty,
    output logic [N-1:0] v_mem,
    output logic [2*N-1:0] p_mem,
    output logic pwm_out
);

logic sample;

logic [2*N-1:0] p, p_avg, p_prev;
logic [N-1:0] v_avg, v_prev;
logic [1:0] ps, vs;
logic rstn;

logic rd_sync, rd_debounce, rd_pulse;

assign rstn = ~rst_btn;
 
`ifndef SYNTHESIS
timer #(.SAMPLING_TIME(1), .FREQ(5000)) timer_unit (
    .clk(clk), 
    .rstn(rstn), 
    .en(en), 
    .sample(sample)
); // 10 ns
`else
timer #(.SAMPLING_TIME(t)) timer_unit (
    .clk(clk), 
    .rstn(rstn), 
    .en(en), 
    .sample(sample)
);
`endif

power_calc #(.N(N)) power_unit (
    .clk(clk), 
    .rstn(rstn), 
    .en(sample), 
    .v(v), 
    .i(i), 
    .p(p)
);

logic done, done_p, done_v;

acc_order #(.N(N), .ORDER(ORDER)) v_acc (
    .clk(clk),
    .rstn(rstn),
    .en(en),
    .sample(sample),
    .q(v),
    .q_avg(v_avg),
    .done(done_v)
);
acc_order #(.N(2*N), .ORDER(ORDER)) p_acc (
    .clk(clk),
    .rstn(rstn),
    .en(en),
    .sample(sample),
    .q(p),
    .q_avg(p_avg),
    .done(done_p)
);

assign done = done_v & done_p;

register #(.N(N)) v_reg (
    .clk(clk), 
    .rstn(rstn), 
    .en(done), 
    .D_in(v_avg), 
    .D_out(v_prev)
);
register #(.N(2*N)) p_reg (
    .clk(clk), 
    .rstn(rstn), 
    .en(done), 
    .D_in(p_avg), 
    .D_out(p_prev)
);

comparator #(.N(N)) v_comp (
    .q1(v_prev), 
    .q2(v_avg),
    .s(vs)
);
comparator #(.N(2*N)) p_comp (
    .q1(p_prev),
    .q2(p_avg),
    .s(ps)
);

always @(posedge clk or negedge rstn) begin
    inc_duty <= 1'b0;
    dec_duty <= 1'b0;
    if (!rstn) begin
        inc_duty <= 1'b0;
        dec_duty <= 1'b0;
    end
    else if (done) begin
        inc_duty = (ps[1] & vs[1]) | (~ps[1] & ps[0] & ~vs[1] & vs[0]);
        dec_duty = (~ps[1] & ps[0] & vs[1]) | (ps[1] & ~ps[0] & vs[0]);
    end
end

//==== Behavioral modelling ====
//always @(posedge clk or negedge rstn) begin
//    if (!rstn) begin
//        inc_duty <= 1'b0;
//        dec_duty <= 1'b0;
//    end
//    else if (en) begin
//        if (p2 < p1) begin
//            if (v2 < v1) inc_duty <= 1'b1;
//            else if (v2 > v1) dec_duty <= 1'b1;
//        end
//        else if (p2 < p1) begin
//            if (v2 < v1) dec_duty <= 1'b1;
//            else if (v2 > v1) inc_duty <= 1'b1;
//        end
//    end
//end

synchronizer sync_rd (
    .clk(clk),
    .rstn(rstn),
    .q(rd),
    .q_sync(rd_sync)
);
`ifndef SYNTHESIS
debouncer #(.COUNT(1)) debounce_rd (
    .clk(clk),
    .rstn(rstn),
    .q_sync(rd_sync),
    .q_debounce(rd_debounce)
);
`else
debouncer debounce_rd (
    .clk(clk),
    .rstn(rstn),
    .q_sync(rd_sync),
    .q_debounce(rd_debounce)
);
`endif
edge_detector edge_detect_rd (
    .clk(clk),
    .rstn(rstn),
    .q_debounce(rd_debounce),
    .q_pulse(rd_pulse)
);

memory #(.N(N), .M(M)) V_mem ( 
    .clk(clk),
    .rstn(rstn),
    .wr(done),
    .rd(rd_pulse),
    .D_in(v_avg),
    .D_out(v_mem)
);
memory #(.N(2*N), .M(M)) P_mem ( 
    .clk(clk),
    .rstn(rstn),
    .wr(done),
    .rd(rd_pulse),
    .D_in(v_avg),
    .D_out(p_mem)
);
  
duty_generator DUTY (
    .clk(clk),
    .rstn(rstn),
    .en(en),
    .inc_duty(inc_duty),
    .dec_duty(dec_duty),
    .pwm_out(pwm_out)
);

endmodule
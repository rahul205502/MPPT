
module duty_generator #(parameter MAX_DUTY = 5000, DUTY_WIDTH = 13) ( // for 20kHz PWM
    input clk, rstn, en,
    input inc_duty, dec_duty,
    output pwm_out
);

logic [DUTY_WIDTH-1:0] duty, count;
localparam DUTY_STEP = MAX_DUTY / 100;

always @(posedge clk or negedge rstn) begin
    if (!rstn) duty <= MAX_DUTY / 2;
    else if (en) begin
        if (inc_duty && !dec_duty) begin
            if (duty < MAX_DUTY) 
                duty <= duty + DUTY_STEP;
        end
        else if (!inc_duty && dec_duty) begin
            if (duty > 0)
                duty <= duty - DUTY_STEP;
         end
    end
end
  
always @(posedge clk or negedge rstn) begin
    if (!rstn) count <= 0;
    else begin
        if (count == MAX_DUTY-1) count <= 0;
        else count <= count + 1;
    end
end

assign pwm_out = duty > count;

endmodule
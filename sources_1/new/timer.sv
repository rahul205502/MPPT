
module timer #(parameter SAMPLING_TIME=1, FREQ=100_000_000) ( // t in seconds
    input clk, rstn, en,
    output logic sample
);

localparam integer CYCLES = SAMPLING_TIME * FREQ; // basys-3 clk frequency = 100 MHz
logic [31:0] count;

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        sample <= 1'b0;
        count <= 0;
    end
    else begin
        sample <= 1'b0;
        if (en) begin
            if (count == CYCLES-1) begin
                sample <= 1'b1;
                count <= 0;
            end
            else count <= count + 1;
        end
        else count <= 0;
    end
end

endmodule 

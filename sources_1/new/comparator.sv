
module comparator #(parameter N=12) (
    input [N-1:0] q1, q2,
    output logic [1:0] s
);

always @(*) begin
    s = (q2==q1) ? 2'b00 : 
        (q2>q1) ? 2'b01 : 2'b10;
end

endmodule
    

module memory #(parameter N=12, M=16) (
    input clk, rstn, wr, rd,
    input [N-1:0] D_in,
    output logic [N-1:0] D_out
); 

logic [$clog2(M)-1:0] addr_wr, addr_rd;
logic [N-1:0] mem [M-1:0];

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        D_out <= 0;
        addr_wr <= 0;
        addr_rd <= 0;
    end
    else begin
        if (wr) begin
            mem[addr_wr] <= D_in;
            addr_wr <= addr_wr + 1;
        end
        if (rd) begin
            D_out <= mem[addr_rd];
            addr_rd <= addr_rd + 1;
        end
    end
end

endmodule
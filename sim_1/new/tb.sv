`timescale 1ns / 1ps

module tb #(parameter N=12, t=1, M=16, ORDER=4);
logic clk, rst, en, rd;
logic [N-1:0] v, i;
logic inc_duty, dec_duty;
logic [N-1:0] v_mem;
logic [2*N-1:0] p_mem;
logic pwm_duty;

mppt_top #(.N(12), .t(1), .M(16), .ORDER(1)) dut (
    .clk(clk),
    .rst_btn(rst),
    .en(en),
    .rd(rd),
    .v(v),
    .i(i),
    .inc_duty(inc_duty),
    .dec_duty(dec_duty),
    .v_mem(v_mem),
    .p_mem(p_mem),
    .pwm_out(pwm_duty)
);

always #5 clk = ~clk;

//task mppt_step (input [11:0] v1, i1, v2, i2); begin
//        // First operating point
//        v = v1;
//        i = i1;
//        en = 1;
//        @(posedge clk);
//        // P1
//        @(posedge clk);
//        // Change operating point
//        @(negedge clk);
//        v = v2;
//        i = i2;
        
//        @(posedge dut.done);
//        en = 0;
//    end
//endtask


//initial begin
//    clk = 0;
//    rst = 1;
//    en = 0;
//    rd = 0;

//    v = 0;
//    i = 0;

//    #20;
//    rst = 0;


//    // =================================================
//    // GAUSSIAN POWER SWEEP
//    //
//    // V       I       P = V*I
//    //
//    // 60      5       300
//    // 65      7       455
//    // 70      9       630
//    // 75      12      900
//    // 80      15      1200
//    // 85      18      1530
//    // 90      20      1800
//    // 95      20      1900
//    // 100     20      2000   <-- MPP
//    // 105     18      1890
//    // 110     16      1760
//    // 115     13      1495
//    // 120     10      1200
//    // 125     7       875
//    // 130     5       650
//    // 135     3       405
//    // 140     2       280
//    //
//    // Power rises up to V=100
//    // Power falls after V=100
//    // =================================================

//    // 60 -> 65
//    mppt_step(60,5, 65,7);
//    // 65 -> 70
//    mppt_step(65,7, 70,9);
//    // 70 -> 75
//    mppt_step(70,9, 75,12);
//    // 75 -> 80
//    mppt_step(75,12, 80,15);
//    // 80 -> 85
//    mppt_step(80,15, 85,18);
//    // 85 -> 90
//    mppt_step(85,18, 90,20);
//    // 90 -> 95
//    mppt_step(90,20, 95,20);
//    // 95 -> 100
//    mppt_step(95,20, 100,20);

//    // ------------------------------------------------
//    // MPP REACHED
//    // ------------------------------------------------

//    // 100 -> 105
//    mppt_step(100,20, 105,18);
//    // 105 -> 110
//    mppt_step(105,18, 110,16);
//    // 110 -> 115
//    mppt_step(110,16, 115,13);
//    // 115 -> 120
//    mppt_step(115,13, 120,10);
//    // 120 -> 125
//    mppt_step(120,10, 125,7);
//    // 125 -> 130
//    mppt_step(125,7, 130,5);
//    // 130 -> 135
//    mppt_step(130,5, 135,3);
//    // 135 -> 140
//    mppt_step(135,3, 140,2);

//    #20;
//    $finish;
//end


task mppt_step (input [11:0] v1, i1); begin
        // First operating point
        en = 1;
        @(posedge dut.sample);
        v = v1;
        i = i1;
        en = 0;
    end
endtask


initial begin
    clk = 0;
    rst = 1;
    en = 0;
    rd = 0;

    v = 0;
    i = 0;

    #10;
    rst = 0;


    // =================================================
    // GAUSSIAN POWER SWEEP
    //
    // V       I       P = V*I
    //
    //1 60      5       300
    //2 65      7       455
    //3 70      9       630
    //4 75      12      900
    //5 80      15      1200
    //6 85      18      1530
    //7 90      20      1800
    //8 95      20      1900
    //9 100     20      2000   <-- MPP
    //10 105     18      1890
    //11 110     16      1760
    //12 115     13      1495
    //13 120     10      1200
    //14 125     7       875
    //15 130     5       650
    //16 135     3       405
    //17 140     2       280
    //
    // Power rises up to V=100
    // Power falls after V=100
    // =================================================

    // 60 -> 65
    mppt_step(60,5);
    // 65 -> 70
    mppt_step(65,7);
    // 70 -> 75
    mppt_step(70,9);
    // 75 -> 80
    mppt_step(75,12);
    // 80 -> 85
    mppt_step(80,15);
    // 85 -> 90
    mppt_step(85,18);
    // 90 -> 95
    mppt_step(90,20);
    // 95 -> 100
    mppt_step(95,20);

    // ------------------------------------------------
    // MPP REACHED
    // ------------------------------------------------

    // 100 -> 105
    mppt_step(100,20);
    // 105 -> 110
    mppt_step(105,18);
    // 110 -> 115
    mppt_step(110,16);
    // 115 -> 120
    mppt_step(115,13);
    // 120 -> 125
    mppt_step(120,10);
    // 125 -> 130
    mppt_step(125,7);
    // 130 -> 135
    mppt_step(130,5);
    // 135 -> 140
    mppt_step(135,3);
    // 140 -> 145
    mppt_step(140,2);
    
//    #20;
    $finish;
end

initial begin

    $monitor(
        "TIME=%0t | V=%0d | I=%0d | P=%0d | INC=%b | DEC=%b",
        $time,
        v,
        i,
        dut.p,
        inc_duty,
        dec_duty,
    );

end

endmodule

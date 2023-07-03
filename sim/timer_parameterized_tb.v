`timescale 1ns / 1ps

module timer_parameterized_tb(

    );
    
    timer_parameterized #(.end_at(10)) DUT(
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .timer_done(timer_done)
        // .Q(Q)
    );
    
    reg clk;
    reg reset_n;
    reg en;
    wire timer_done;
    // wire [3:0] Q;
    
    localparam T = 10;
    always
    begin
        clk = 1'b0;
        # (T/2);
        clk = 1'b1;
        # (T/2);
    end
        
    initial
    begin
        en = 1;
        reset_n = 1;
        #1;
        reset_n = 0;
        #1;
        reset_n = 1;
    end
endmodule // TIMER_PARAMETERIZED_TB

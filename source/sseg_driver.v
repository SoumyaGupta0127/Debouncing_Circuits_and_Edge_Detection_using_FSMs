`timescale 1ns / 1ps

module sseg_driver(
    input clk,
    input reset_n,
    input [5:0] I0, I1, I2, I3, I4, I5, I6, I7,
    output [7:0] AN,
    output [6:0] sseg,
    output DP
    );
    
    wire timer_tick;
    wire [2:0] sel;
    wire [5:0] D_out;
    wire [7:0] AN_n;
    
    udl_counter #(.BITS(3)) UP_COUNTER(
        .clk(clk),
        .reset_n(reset_n),
        .en(timer_tick),
        .up(1'b1),
        .load(1'b0),
        .D(),
        .Q(sel)        
    );
    
    timer_parameterized #(.end_at(104_165)) TIMER(
        .clk(clk),
        .reset_n(reset_n),
        .en(1'b1),
        .timer_done(timer_tick)        
    );
    
    decoder_generic #(.N(3))DECODER(
        .w(sel),
        .en(D_out[5]),
        .y(AN_n)
    );
    
    assign AN = ~AN_n;
    
    mux_8x1_nbit #(.N(6)) MUX8X1(
        .w0(I0),
        .w1(I1),
        .w2(I2),
        .w3(I3),
        .w4(I4),
        .w5(I5),
        .w6(I6),
        .w7(I7),
        .s(sel),
        .f(D_out)        
    );
    
    hex2sseg HEX_DECODER(
        .hex(D_out[4:1]),
        .sseg(sseg)
    );
    
    assign DP = ~D_out[0];
    
endmodule // SSEG_DRIVER

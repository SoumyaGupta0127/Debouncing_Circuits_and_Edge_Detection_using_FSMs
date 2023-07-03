`timescale 1ns / 1ps

module button_fpga(
    input clk,
    input reset_n,
    input button_input,
    output [7:0] AN,
    output [6:0] sseg,
    output DP
    );
        
    // Button with debouncer and positive edge detector
    wire p_edge_deb;
    wire [3:0] Q_deb;
    
    button DEBOUNCED_BUTTON (
        .clk(clk),
        .reset_n(reset_n),
        .noisy_input(button_input),
        .debounced_output(),
        .p_edge(p_edge_deb),
        .n_edge(),
        .any_edge()
    );
    
    // Debounced button counter
    udl_counter #(.BITS(4)) DEBOUNCED_BUTTON_COUNTER (
        .clk(clk),
        .reset_n(reset_n),
        .en(p_edge_deb),
        .up(1'b1),
        .load(),
        .D(),
        .Q(Q_deb)
    );
    
    // Button without debouncer and with positive edge detector
    wire p_edge_undeb;
    wire [3:0] Q_undeb;

    edge_detector UNDEBOUNCED_BUTTON(
        .clk(clk),
        .reset_n(reset_n),
        .in(button_input),
        .p_edge(p_edge_undeb),
        .n_edge(),
        .any_edge()
    );
    
    // Undebounced button counter
    udl_counter #(.BITS(4)) UNDEBOUNCED_BUTTON_COUNTER (
        .clk(clk),
        .reset_n(reset_n),
        .en(p_edge_undeb),
        .up(1'b1),
        .load(),
        .D(),
        .Q(Q_undeb)
    );
    
    // Seven-Segment Display of both counters
    sseg_driver SSEG_DRIVER(
        .clk(clk),
        .reset_n(reset_n),
        .I0({1'b1, Q_undeb, 1'b0}),
        .I1(6'b000_000),
        .I2(6'b000_000),
        .I3(6'b000_000),
        .I4({1'b1, Q_deb, 1'b0}),
        .I5(6'b000_000),
        .I6(6'b000_000),
        .I7(6'b000_000),
        .AN(AN),
        .sseg(sseg),
        .DP(DP)
    );
    
endmodule // BUTTON_FPGA
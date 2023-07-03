`timescale 1ns / 1ps

module button(
    input clk,
    input reset_n,
    input noisy_input,
    output debounced_output,
    output p_edge,
    output n_edge,
    output any_edge
    );
    
    debouncer_delayed DD(
        .clk(clk),
        .reset_n(reset_n),
        .noisy_input(noisy_input),
        .debounced_output(debounced_output)
    );
    
    edge_detector ED(
        .clk(clk),
        .reset_n(reset_n),
        .in(debounced_output),
        .p_edge(p_edge),
        .n_edge(n_edge),
        .any_edge(any_edge)
    );
    
endmodule // BUTTON 

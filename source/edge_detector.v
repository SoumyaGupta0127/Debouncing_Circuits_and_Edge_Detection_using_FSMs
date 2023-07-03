`timescale 1ns / 1ps

module edge_detector(
    // MEALY FSM
    input clk,
    input reset_n,
    input in,
    output p_edge,
    output n_edge,
    output any_edge
    );
    
    reg state_reg, state_next;
    parameter s0 = 0;
    parameter s1 = 1;
    
    // Sequential state registers
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
            state_reg <= s0;
        else
            state_reg <= state_next;
    end
    
    // Next state logic
    always @(*)
    begin
        case(state_reg)
            s0: if (in)
                    state_next = s1;
                else
                    state_next = s0;
            s1: if (in)
                    state_next = s1;
                else
                    state_next = s0;
            default: state_next = s0;                
        endcase
    end
    
    // Output logic
    assign p_edge = (state_reg == s0) & in;
    assign n_edge = (state_reg == s1) & ~in;
    assign any_edge = p_edge | n_edge;
    
endmodule // EDGE_DETECTOR

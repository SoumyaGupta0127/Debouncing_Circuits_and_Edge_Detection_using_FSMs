`timescale 1ns / 1ps
 
module debouncer_early_fsm(
    // MOORE FSM
    input clk,
    input reset_n,
    input noisy_input,
    input timer_done,
    output timer_reset,
    output debounced_output
    );
    
    reg [1 : 0] state_reg, state_next;
    
    parameter s0 = 0;
    parameter s1 = 1;
    parameter s2 = 2;
    parameter s3 = 3;
    
    // Sequential state register
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
            state_reg <= 0;
        else
            state_reg <= state_next;
    end
    
    // Next state logic
    always @(*)
    begin
        state_next = state_reg;
        case(state_reg)
            s0: if (~noisy_input)
                    state_next = s0;
                else if (noisy_input)
                    state_next = s1;
            s1: if (~noisy_input)
                    state_next = s1;
                else if (noisy_input & ~timer_done)
                    state_next = s1;
                else if (noisy_input & timer_done)
                    state_next = s2;
            s2: if (~noisy_input)
                    state_next = s3;
                else if (noisy_input)
                    state_next = s2;
            s3: if (noisy_input)
                    state_next = s3;
                else if (~noisy_input & ~timer_done)
                    state_next = s3;
                else if (~noisy_input & timer_done)
                    state_next = s0;
            default: state_next = s0;                                             
        endcase
    end
    
    // Output logic
    assign timer_reset = (state_reg == s0) | (state_reg == s2);
    assign debounced_output = (state_reg == s1) | (state_reg == s2);
    
endmodule // DEBOUNCER_EARLY_FSM

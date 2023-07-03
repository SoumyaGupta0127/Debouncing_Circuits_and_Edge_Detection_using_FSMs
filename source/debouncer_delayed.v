`timescale 1ns / 1ps

module debouncer_delayed
    #(parameter timer = 2_000_000) // Default timer = 2M clk cycles
    (
    input clk,
    input reset_n,
    input noisy_input,
    output debounced_output
    );
    
    wire timer_done;
    wire timer_reset;
    
    // T clk cycles timer
    timer_parameterized #(.end_at(timer - 1)) TIMER(
        .clk(clk),
        .reset_n(~timer_reset),
        .en(~timer_reset),
        .timer_done(timer_done)
    );
    
    // Debouncer delayed FSM
    debouncer_delayed_fsm FSM(
        .clk(clk),
        .reset_n(reset_n),
        .noisy_input(noisy_input),
        .timer_done(timer_done),
        .debounced_output(debounced_output),
        .timer_reset(timer_reset)
    );
    
endmodule // DEBOUNCER_DELAYED
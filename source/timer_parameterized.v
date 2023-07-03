`timescale 1ns / 1ps

module timer_parameterized
    #(parameter end_at = 255)
    (
    input clk,
    input reset_n,
    input en,
    // output [BITS - 1 : 0] Q,
    output timer_done
    );
    
    localparam BITS = $clog2(end_at);
    
    reg [BITS - 1 : 0] Q_reg, Q_next;
    
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
            Q_reg <= 'b0;
        else if(en)
            Q_reg <= Q_next;
        else
            Q_reg <= Q_reg;
    end
    
    // Next state logic  
    always @(*)
        Q_next = timer_done? 'b0: Q_reg + 1;
        
    // Output logic
    assign timer_done = (Q_reg == end_at);
    // assign Q = Q_reg;
    
endmodule // TIMER_PARAMETERIZED

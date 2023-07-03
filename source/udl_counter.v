`timescale 1ns / 1ps

module udl_counter
    #(parameter BITS = 4)(
    input clk,
    input reset_n,
    input en,
    input up,
    input load,
    input [BITS - 1:0] D,
    output [BITS - 1:0] Q
    );
    
    reg [BITS - 1:0] Q_reg, Q_next;
    
    // Sequential state register
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
    always @(Q_reg, up, load, D)
    begin
        Q_next = Q_reg;
        casex({load,up})
            2'b00: Q_next = Q_reg - 1;
            2'b01: Q_next = Q_reg + 1;
            2'b1x: Q_next = D;
            default: Q_next = Q_reg;
        endcase       
    end
    
    // Output logic
    assign Q = Q_reg;
    
endmodule // UDL_COUNTER

`timescale 1ns / 1ps

module button_tb(

    );
    
    reg clk;
    reg reset_n;
    reg noisy_input;
    wire debounced_output;
    integer i;
    wire p_edge;
    wire n_edge;
    wire any_edge;
    
    button DUT(
        .clk(clk),
        .reset_n(reset_n),
        .noisy_input(noisy_input),
        .debounced_output(debounced_output),
        .p_edge(p_edge),
        .n_edge(n_edge),
        .any_edge(any_edge)
    );
    
    // Generating a clk signal
    localparam T = 10;
    always
    begin
        clk = 1'b0;
        #(T / 2);
        clk = 1'b1;
        #(T / 2);
    end
    
    localparam DELAY = 50_000_000; // Delay of 50 ms
    
    initial
    begin
        reset_n = 1'b0;
        noisy_input = 1'b0;
        #2  
        reset_n = 1'b1;
        
        repeat(2) @(negedge clk);
        noisy_input = 1'b1;
        
        #(DELAY);
        noisy_input = 1'b0;
        
        #(DELAY);
        
        repeat(20) @(negedge clk);
        for (i = 0; i < 5; i = i + 1)       
            #(DELAY/40) noisy_input = ~noisy_input;
        
        #(DELAY/2);
        for (i = 0; i < 5; i = i + 1)       
            #(DELAY/40) noisy_input = ~noisy_input;

        #(DELAY/2);
        noisy_input = ~noisy_input;
        for (i = 0; i < 5; i = i + 1)       
            #(DELAY/40) noisy_input = ~noisy_input;
                    
        #(DELAY/2);
        noisy_input = ~noisy_input;
        
        #(DELAY/2);
        for (i = 0; i < 6; i = i + 1)       
            #(DELAY/40) noisy_input = ~noisy_input;

        #(DELAY/2) noisy_input = 1'b0;                                                
        #(DELAY) $stop;   
    end        
    
endmodule // BUTTON_TB
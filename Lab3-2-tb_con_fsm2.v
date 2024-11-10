`timescale 1ns / 1ps

module tb_con_fsm2;
    reg sys_clk;
    reg sys_rst_n;
    reg pi_money_half;
    reg pi_money_one;
    reg pi_refund;
    
    wire po_cola;
    wire po_money;
    
    con_fsm uut (
        .sys_clk(sys_clk), 
        .sys_rst_n(sys_rst_n), 
        .pi_money_half(pi_money_half), 
        .pi_money_one(pi_money_one), 
        .pi_refund(pi_refund), 
        .po_cola(po_cola), 
        .po_money(po_money)
    );

    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk; // 10 ns clock period
    end
    
    initial begin
        // Initialize inputs
        sys_rst_n = 0;
        pi_money_half = 0;
        pi_money_one = 0;
        pi_refund = 0;
        
        // Reset the system
        #10 sys_rst_n = 1;

        // Scenario 1: Insert half money, then request refund
        #10 pi_money_half = 1; 
        #10 pi_money_half = 0;
        
        #10 pi_refund = 1;    
        #10 pi_refund = 0;
        
        // Scenario 2: Insert full money, dispense cola
        #10 pi_money_one = 1; 
        #10 pi_money_one = 0;
        
        #10 pi_money_one = 1; 
        #10 pi_money_one = 0;
        
        // Scenario 3: Insert half money, then full money, dispense cola
        #10 pi_money_half = 1; 
        #10 pi_money_half = 0;
        
        #10 pi_money_one = 1;  
        #10 pi_money_one = 0;
        
        // Scenario 4: Insert half money, then request refund
        #10 pi_money_half = 1; 
        #10 pi_money_half = 0;
        
        #10 pi_refund = 1; 
        #10 pi_refund = 0;

        #20 $finish;
    end

    initial begin
        $monitor("Time=%0d, sys_rst_n=%b, pi_money_half=%b, pi_money_one=%b, pi_refund=%b, po_cola=%b, po_money=%b", 
                  $time, sys_rst_n, pi_money_half, pi_money_one, pi_refund, po_cola, po_money);
    end

endmodule

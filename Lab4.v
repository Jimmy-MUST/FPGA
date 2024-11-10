module con_fsm
(
input wire sys_clk, 
input wire sys_rst_n, 
input wire pi_money_half, 
input wire pi_money_one,
input wire pi_refund, // New input for refund request
    
output reg po_cola,
output reg po_money
);

parameter IDLE     = 4'b0001;
parameter HALF     = 4'b0010;
parameter ONE      = 4'b0100;
parameter ONE_HALF = 4'b1000;

wire [1:0] pi_money;
reg [4:0] state;

assign pi_money = {pi_money_one, pi_money_half};

// State machine for transitions
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (sys_rst_n == 1'b0) 
        state <= IDLE;
    else 
        case(state)
            IDLE: if (pi_money == 2'b01) 
                      state <= HALF;
                  else if (pi_money == 2'b10)
                      state <= ONE;
                  else
                      state <= IDLE;
            HALF: if (pi_money == 2'b01) 
                      state <= ONE;
                  else if (pi_money == 2'b10)
                      state <= ONE_HALF;
                  else if (pi_refund)
                      state <= IDLE; // Handle refund in HALF state
                  else
                      state <= HALF;
            ONE: if (pi_money == 2'b01) 
                     state <= ONE_HALF;
                 else if (pi_money == 2'b10)
                     state <= IDLE;
                 else if (pi_refund)
                     state <= IDLE; // Handle refund in ONE state
                 else
                     state <= ONE;
            ONE_HALF: if ((pi_money == 2'b01) || (pi_money == 2'b10))
                          state <= IDLE;
                      else if (pi_refund)
                          state <= IDLE; // Handle refund in ONE_HALF state
                      else
                          state <= ONE_HALF;
            default: state <= IDLE;
        endcase
end

// Output logic for dispensing cola
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (sys_rst_n == 1'b0) 
        po_cola <= 1'b0;
    else if ((state == ONE && pi_money == 2'b10)
             || (state == ONE_HALF && pi_money == 2'b01)
             || (state == ONE_HALF && pi_money == 2'b10))
        po_cola <= 1'b1;
    else 
        po_cola <= 1'b0;
end

// Output logic for returning money
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (sys_rst_n == 1'b0)
        po_money <= 1'b0;
    else if (pi_refund) begin
        case (state)
            HALF: po_money <= 1'b1;  // Return half amount if in HALF state
            ONE: po_money <= 1'b1;   // Return full amount if in ONE state
            ONE_HALF: po_money <= 1'b1;  // Return full amount if in ONE_HALF state
            default: po_money <= 1'b0;
        endcase
    end else if (state == ONE_HALF && pi_money == 2'b10) 
        po_money <= 1'b1;
    else 
        po_money <= 1'b0;
end

endmodule

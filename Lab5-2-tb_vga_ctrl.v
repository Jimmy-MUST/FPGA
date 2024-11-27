`timescale 1ns/1ns
module tb_vga_ctrl();

 wire [9:0] pix_x ; 
 wire [9:0] pix_y ; 
 wire hsync ; 
 wire vsync ; 
 wire [15:0] rgb; 


 reg [15:0] pix_data ;
 reg vga_clk ;
 reg rst_n ;




 initial begin
	 vga_clk = 1'b1;
	 rst_n <= 1'b0;
	 #200
	 rst_n <= 1'b1;
 end

 
 always #20 vga_clk = ~vga_clk;


 
 always@(posedge vga_clk or negedge rst_n) begin
	 if(rst_n == 1'b0)
		pix_data <= 16'h0000;
	 else
		pix_data <= 16'hffff;
 end
 

 wire [9:0] cnt_h = vga_ctrl_inst.cnt_h;
 wire [9:0] cnt_v = vga_ctrl_inst.cnt_v;

 vga_ctrl vga_ctrl_inst
 (
 .vga_clk (vga_clk ), 
 .sys_rst_n (rst_n ), 
 .pix_data (pix_data ), 

 .pix_x (pix_x ), 
 .pix_y (pix_y ), 
 .hsync (hsync ), 
 .vsync (vsync ), 
 .rgb (rgb ) 
 );

 endmodule
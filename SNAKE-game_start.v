`define RED    24'hFF0000    
`define GREEN  24'h00FF00        
`define BLUE   24'h0000FF        
`define PURPLE 24'hFF00FF     
`define YELLOW 24'hFFFF00       
`define CYAN   24'h00FFFF         
`define ORANGE 24'hFFC125       
`define WHITE  24'hFFFFFF        
`define BLACK  24'h000000   

`define S1_POS  (pix_x>220&&pix_x<421&&pix_y>140&&pix_y<341) 

module game_start(
    input   wire            tft_clk_9m  ,   
    input   wire            sys_rst_n   ,   

    input  wire    [9:0]   pix_x       ,   
    input  wire    [9:0]   pix_y       ,  
    output  reg    [23:0]    rgb_data     ,   
    input  wire             hsync       ,  
    input  wire             vsync         
       );

reg [15:0] s1_addr;
wire [0:0] s1;


always @(posedge tft_clk_9m or negedge sys_rst_n) begin
  if(!sys_rst_n) begin
     rgb_data <= `BLACK;
	  s1_addr<=0;

  end
  else begin
    if(vsync == 1'b1)
      if(`S1_POS)begin
		  s1_addr <= s1_addr + 1;
	     rgb_data <= {24{s1}};
	   end
	   else begin
	     rgb_data <= `BLACK; 
		end
	 else begin
	   s1_addr<=0;
	   rgb_data <= `BLACK;
	 end
  end
end

rom_st Urom_st(
       .clock(tft_clk_9m), 
		 .address(s1_addr), 
		 .q(s1)
		 );

endmodule


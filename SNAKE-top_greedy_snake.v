module top_greedy_snake
(
    input clk,
	input rst_n,
	
	input left,
	input right,
	input up,
	input down,
	
	//output                  beep,           
	output  wire    [3:0]   led_out,      

	output hsync,
	output vsync,
	output  wire    [15:0]  rgb          

	
);

	wire left_key_press;
	wire right_key_press;
	wire up_key_press;
	wire down_key_press;
	wire [1:0]snake;
	wire [9:0]x_pos;
	wire [9:0]y_pos;
	wire [5:0]apple_x;
	wire [4:0]apple_y;
	wire [5:0]head_x;
	wire [5:0]head_y;
	
	wire add_cube;
	wire[1:0]game_status;
	wire hit_wall;
	wire hit_body;
	wire die_flash;
	wire restart;
	wire [6:0]cube_num;
	

wire pixel_clk;//74.25MHZ

wire  [23:0]  vga_rgb;  
wire [7:0]	   R;
wire [7:0]	   G;
wire [7:0]	   B; 
wire		      HS;
wire	         VS;
wire           VGA_DE;
	
wire [23:0]    start_rgb;
wire [23:0]    over_rgb;
				
assign led_out={4{die_flash}};
assign point=6'b000000;
assign seg_en=1'b1;
assign sign=1'b0;
	
assign hsync= HS;
assign vsync=VS;

assign rgb  =(game_status==2'b10)?{R[7:3],G[7:2],B[7:3]}:       
             (game_status==2'b01)?{start_rgb[23:19],start_rgb[15:10],5'b0}:{over_rgb[23:19],6'b0,5'b0};
  
clk_gen clk_gen_inst
(
    .areset     (~rst_n ),  
    .inclk0     (clk    ),  
    .c0         (pixel_clk ),  

    .locked     (     )   
);


    Game_Ctrl_Unit U1 (
        .clk(clk),
	    .rst(rst_n),
	    .key1_press(left_key_press),
	    .key2_press(right_key_press),
	    .key3_press(up_key_press),
	    .key4_press(down_key_press),
        .game_status(game_status),
		.hit_wall(hit_wall),
		.hit_body(hit_body),
		.die_flash(die_flash),
		.restart(restart)		
	);
	
	Snake_Eatting_Apple U2 (
        .clk(clk),
		.rst(rst_n&restart),
		.apple_x(apple_x),
		.apple_y(apple_y),
		.head_x(head_x),
		.head_y(head_y),
		.add_cube(add_cube)	
	);
	
	Snake U3 (
	    .clk(clk),
		.rst(rst_n&restart),
		.left_press(left_key_press),
		.right_press(right_key_press),
		.up_press(up_key_press),
		.down_press(down_key_press),
		.snake(snake),
		.x_pos(x_pos),
		.y_pos(y_pos),
		.head_x(head_x),
		.head_y(head_y),
		.add_cube(add_cube),
		.game_status(game_status),
		.cube_num(cube_num),
		.hit_body(hit_body),
		.hit_wall(hit_wall),
		.die_flash(die_flash)
	);
	
//--------------------------------	

	Snake_VGA USnake_VGA(
       .clk(pixel_clk),
       .rst_n(rst_n&restart),
       .snake(snake),
	   .apple_x(apple_x),
	   .apple_y(apple_y),
	   .x_pos(x_pos),
	   .y_pos(y_pos),
	   .vga_rgb(vga_rgb)
       ); 
	     
  vga_ctl U_vga_ctl(
        .pix_clk(pixel_clk),
        .reset_n(rst_n),
        .VGA_RGB(vga_rgb),
        .hcount(x_pos),
        .vcount(y_pos),
		  .VGA_CLK(),
        .VGA_R(R),
        .VGA_G(G),
        .VGA_B(B),
        .VGA_HS(HS),
        .VGA_VS(VS),
        .VGA_DE(VGA_DE),
        .BLK()
        );  
		  
//-----------------------------------
game_start Ugame_start(
           .tft_clk_9m(pixel_clk),   
           .sys_rst_n(rst_n),   

           .pix_x(x_pos),   
           .pix_y(y_pos),   
           .rgb_data(start_rgb),  
           .hsync(HS)      ,  
           .vsync(VS)         
       );

		 
game_over Ugame_over(
           .tft_clk_9m(pixel_clk),   
           .sys_rst_n(rst_n),   

           .pix_x(x_pos),   
           .pix_y(y_pos),   
           .rgb_data(over_rgb),   
           .hsync(HS)      ,   
           .vsync(VS)         
       );
		 
//----------------------------------

	Key U5 (
		.clk(clk),
		.rst(rst_n),
		.left(left),
		.right(right),
		.up(up),
		.down(down),
		.left_key_press(left_key_press),
		.right_key_press(right_key_press),
		.up_key_press(up_key_press),
		.down_key_press(down_key_press)		
	);
	
	



endmodule

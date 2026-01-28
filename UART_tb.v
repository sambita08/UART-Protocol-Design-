`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:Sambita dutta  
// 
// Create Date: 14.01.2026 23:45:52
// Design Name: 
// Module Name: UART_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_tb;

reg clk, rst;
reg [7:0] data_in;
reg wr_en;  

wire rdy;
reg rdy_clr;
wire [7:0] dout;
wire busy;

uart_top test_uart (
    .rst(rst),
    .data_in(data_in),
    .wr_en(wr_en),
    .clk(clk),
    .rdy_clr (rdy_clr),
    .rdy(rdy),
    .busy(busy),
    .data_out(dout));
    
initial 
begin
    {clk, rst, data_in, rdy_clr} = 0;
end   

always #5 clk = ~clk;

task send_byte(input [7:0]din); // a task to send 8 bits of data
begin 
        @(negedge clk);
        data_in= din;
        wr_en= 1'b1;
       
        @(negedge clk)
        wr_en= 0;
 end
 endtask
 
    task clear_ready;   // task to set clear after data is transmitted
    begin
         @(negedge clk)
         rdy_clr= 1'b1; //clearing the whole bar for next new operation
         @(negedge clk)
         rdy_clr= 1'b0;  
     end
     endtask 
     
     initial 
     begin
         @(negedge clk)
         rst= 1'b1;
          @(negedge clk)
         rst= 1'b0;
        
        send_byte(8'h41);
        wait(!busy); //wait till busy is 0 
        wait(rdy); //rx ready to recieve 
        $display("recived data is %h", dout);
        clear_ready;  //calling this specific task       
        
       
        
        send_byte(8'h55);
        wait(!busy); //wait till busy is 0 
        wait(rdy); //rx ready to recieve 
        $display("recived data is %h", dout);
        clear_ready;  //calling this specific task       
    
        #400 $finish;
      end      

endmodule


/* wr_en is not refreshing to one, might be becuz 
the clear_rdy task  wasnt called successfully 
OR tx module has issues w wr_en
OR in testbench need to initialise wr_en in sm sorta way */

/*DUE TO THIS , we only get 41 but transferred not 55 */

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:Sambita dutta 
// 
// Create Date: 14.01.2026 23:27:10
// Design Name: 
// Module Name: uart_top
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

/*this module integartes the components of UART interfsce including
 a baud rate generator, a transmitter and a receiver. it handles 
 both transmitting and receiving data at a specified baud rate, controlled
 by enabling signals*/
 
 
module uart_top(
 input rst,
 input [7:0] data_in,
 input wr_en, clk, rdy_clr,
 output rdy, busy,
 output [7:0] data_out);
 
 wire rx_clk_en; // collection o/p of baud rate gen. rx_en signal
 wire tx_clk_en; // collection o/p of baud rate gen. tx_en signal
 wire tx_temp;  // collecting output of tx module 
 
 
 // instantiation 
 baud_rate_gen bg (
    .clk(clk), 
    .tx_en(tx_clk_en), 
    .rx_en(rx_clk_en));
      
 transmitter tx (
    .clk(clk),
    .wr_en(wr_en), 
    .enb(tx_clk_en),
    .rst(rst),
    .data_in(data_in),
    .tx(tx_temp),
    .busy(busy));
    
 reciever rx (
      .clk(clk),
      .rst (rst),
      .rx(tx_temp),
      .rdy_clr (rdy_clr),
      .clk_en(rx_clk_en),
      .rdy(rdy),
      .data_out(data_out));
      
 
 
 

endmodule

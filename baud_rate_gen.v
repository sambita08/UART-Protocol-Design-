`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Sambita dutta 
// 
// Create Date: 14.01.2026 21:45:21
// Design Name: 
// Module Name: baud_rate_gen
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



//for 9600 bps baud rate 
module baud_rate_gen (
input clk,  
output tx_en, 
output rx_en );

reg [12:0] tx_counter = 0;
reg [9:0] rx_counter = 0;

 always @ (posedge clk)
    begin 
    if(tx_counter == 5208) //transmitter, master counter
        tx_counter = 0;
    else 
        tx_counter = tx_counter +1'b1; 
    end   


 always @ (posedge clk)
    begin 
      if(rx_counter == 325) //receiver, slave counter, OVERSAMPLED by 16
        rx_counter = 0;
    else 
        rx_counter = rx_counter +1'b1; 
    end   
    
    
    assign tx_en = (tx_counter == 0)? 1'b1:1'b0;
    assign rx_en = (rx_counter == 0)? 1'b1:1'b0; 


endmodule

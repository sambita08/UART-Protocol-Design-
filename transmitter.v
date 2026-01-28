`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Sambita dutta 
// 
// Create Date: 14.01.2026 21:43:35
// Design Name: 
// Module Name: transmitter
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


module transmitter(
input clk, wr_en, enb, rst, //wr_en is the write enable signal for transmission while enb is for clock enable signal
input [7:0] data_in,
output reg tx, //serial output transmitting data
output busy); //to check if transmitter is busy 

parameter idle_state = 2'b00; //waiting for the enable signal
parameter start_state = 2'b01; //start bits transmission
parameter data_state = 2'b10; //data bits transmission
parameter stop_state = 2'b11; //stop bits transmission for completion of the cycle

reg [7:0] data = 8'h00; //buffer state to hold data 
reg [2:0] index = 3'h0;  // bit position counter 
reg [1:0] state = idle_state; //current state of fsm

    always@ (posedge clk)
    begin
    if(rst)                
    tx=1'b1;  //transmission line = high, so state is idle
    end
    
always@ (posedge clk) 
    begin       
        case(state)
        
        idle_state:
            begin
            if(wr_en) // enable signal to show if data is sent or not
            begin
            state <= start_state;
            data <= data_in;              //Load data
            index <= 3'h0;               //reset bit position
            end
            else
            state <= idle_state;
            end
            
          start_state:
            begin
            if(enb)  // enable signal given by baud rate generator 
            begin
            tx <= 1'b0;   //reset bit position
            state <= data_state; 
            end
            else
            state <= start_state;
            end 
            
            
          data_state: //one by one bits are sent
            begin
            if(enb)
            begin
            if(index == 3'h7)       //checking if all bits are transmitted
               state <= stop_state;
            else                      
               index <= index + 3'h1;
            tx <= data[index];      //after seeing at which index data is at, it is sent to the tx
  
            end
            end
           
          stop_state:
            begin
            if (enb)
            begin
            tx <=1'b1;
            state <=idle_state;
            end
            end 
            
          default:
            begin
            tx <= 1'b1;         //transmit stop bit = logic high, return to idle
            state <=idle_state;
            end
          endcase
    end
            
   assign busy = (state != idle_state);
         
endmodule

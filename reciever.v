`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Sambita Dutta
// 
// Create Date: 14.01.2026 22:23:21
// Design Name: 
// Module Name: reciever
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


module reciever(
input clk, rst, rx, rdy_clr, clk_en, //rx is serial input receiving data, rdy_clr to clear the ready state
output  reg rdy, //indicating data is ready to be read
output reg [7:0] data_out );

parameter start_state = 2'b00;      //waiting for start bit
parameter data_out_state = 2'b01;   //receiving data bits
parameter stop_state = 2'b10;       //checking stop bit

reg [1:0] state = start_state;      //initial state
reg [3:0] sample=0;
reg [3:0] index = 0;
reg [7:0] temp_register = 8'b0;     //temporary reg to store incoming data

always @(posedge clk)
    begin
    if(rst)
    begin
    rdy =0;
    data_out=0;
    end
    end 
    
always @(posedge clk)
    begin
    if(rdy_clr)
        rdy <=0; //reset ready signal when cleared
   
        
    if(clk_en)
    case(state)
        
        start_state: 
            begin
            if( !rx  || sample !=0)
                sample <= sample +4'b1;   //increment sample counter
            if(sample ==15)                //full bit has been sampled
                begin
                state <= data_out_state;
                sample <=0;
                index <=0;
                temp_register <=0;
                end    
            end 
            
         data_out_state: 
             begin 
              sample <= sample +4'b1;
              if( sample == 4'h8)           //sample at middle point 
                begin 
                temp_register[index] <=rx;  //store bit in register
                index <= index + 4'b1;      //move to next bit
                end 
             if (index == 8 && sample ==15)
                state <=stop_state;
              end
              
           stop_state:
             begin
             if(sample ==15)
                 begin
                 state <=start_state;       //reset to start for new tx
                 data_out <=temp_register;  //transfer rx data
                 rdy <= 1'b1;               //indicate data ready
                 sample <=0;
                 end else
                 sample <=sample+ 4'b1 ; //continue sampling stop bit
               end
               
            default : 
            begin 
            state <= start_state;
            end    
        endcase          
      end     
    endmodule

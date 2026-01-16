`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Engineer: SATYAM
// Create Date: 24.12.2025 20:21:48
// Design Name: 
// Module Name: async_fifo
// Project Name: async fifo
// Target Devices: 
// Tool Versions: 
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module async_fifo#(
     parameter FIFO_WIDTH = 8,     // DATA WIDTH
     parameter PTR_WIDTH = 3
    )(
      input wclk,rclk,
      input w_en,r_en,
      input [PTR_WIDTH:0]b_wptr,b_rptr,
      input full,empty,
      input [FIFO_WIDTH-1:0] data_in,
      output reg [FIFO_WIDTH-1:0] data_out   
    );
    
    // fifo-depth  = 1 * 2^PTR_WIDTH
     localparam FIFO_DEPTH = 1 << PTR_WIDTH;
     
    // fifo memory
      reg [FIFO_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];
     
    // write operation
     always@(posedge wclk) begin
            if(w_en & !full)  begin
                fifo[b_wptr[PTR_WIDTH-1:0]] <= data_in;
             end
      end
      
     // read operation
//      always@(posedge rclk) begin
//            if(r_en & !empty)  begin
//                data_out <= fifo[b_rptr[PTR_WIDTH-1:0]];
//             end
//      end
       assign data_out = fifo[b_rptr[PTR_WIDTH-1:0]];


        
                
endmodule

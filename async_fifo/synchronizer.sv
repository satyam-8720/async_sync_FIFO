`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Engineer: SATYAM
// 
// Create Date: 21.12.2025 12:10:03
// Design Name: 
// Module Name: synchronizer
// Project Name: async_fifo

//////////////////////////////////////////////////////////////////////////////////

// 2 FLIP FLOP SYNCHRONIZER
module synchronizer#(
         parameter PTR_WIDTH=3
      )(
         input clk,
         input rst_n,
         input [PTR_WIDTH:0] d_in,
         output reg[PTR_WIDTH:0] d_out 
    );
    reg [PTR_WIDTH:0] q1; // output of 1st FF
    
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            q1 <= 0;
            d_out <=0;
        end
        
        else begin
            q1 <= d_in;
            d_out <= q1;
        end
    end          
endmodule

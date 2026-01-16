`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: SATYAM
// Create Date: 24.12.2025 19:18:53
// Design Name: 
// Module Name: rd_ptr_handler
// Project Name:  async fifo
// Description: 

//////////////////////////////////////////////////////////////////////////////////


module rd_ptr_handler#(
      parameter PTR_WIDTH=3 
    )(
       input rclk,
       input rrst_n,
       input r_en,
       input [PTR_WIDTH:0]   g_wptr_sync,
       output reg [PTR_WIDTH:0]  b_rptr,g_rptr,
       output reg empty
       );
       
       reg [PTR_WIDTH:0] b_rptr_next,g_rptr_next;
       wire rempty;
       
       assign b_rptr_next = b_rptr + (!empty & r_en);
       assign g_rptr_next = b_rptr_next ^ (b_rptr_next >> 1);
        assign rempty = (g_wptr_sync == g_rptr_next);
        
       always@(posedge rclk or negedge rrst_n) begin
            if(!rrst_n) begin
                b_rptr <= 0;
                g_rptr <= 0;
               // empty  <= 1;
             end
            else begin
                b_rptr <= b_rptr_next;
                g_rptr <= g_rptr_next;
               // empty  <= rempty;
             end
        end
       
       always@(posedge rclk or negedge rrst_n) begin
            if(!rrst_n) empty <= 1;
            else        empty <= rempty;
        end
       
endmodule

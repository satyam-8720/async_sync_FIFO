`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Engineer:  SATYAM
// 
// Create Date: 21.12.2025 11:23:57
// Design Name: 
// Module Name: async_fifo
// Project Name: async fifo
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////



module top_module#(
    parameter FIFO_WIDTH = 8,
    parameter PTR_WIDTH = 3
    )(
    // write domain
      input wclk,
      input w_en,
      input wrst_n,
      input [FIFO_WIDTH-1:0]data_in,
      output wire full, 
      
    // read domain
      input rclk,
      input r_en,
      input rrst_n,
      output wire [FIFO_WIDTH-1:0]data_out,
      output wire empty
      );
      
      localparam FIFO_DEPTH = 1 << (PTR_WIDTH);   // 1 * 2^(PTR_WIDTH) 
      
      wire [PTR_WIDTH:0] g_wptr,g_rptr;
      wire [PTR_WIDTH:0] b_wptr,b_rptr;
      wire [PTR_WIDTH:0] g_wptr_sync,g_rptr_sync;


      synchronizer #(PTR_WIDTH) sync_wptr(rclk,rrst_n,g_wptr,g_wptr_sync);
      synchronizer #(PTR_WIDTH) sync_rptr(wclk,wrst_n,g_rptr,g_rptr_sync);
      
      wrt_ptr_handler #(PTR_WIDTH) wptr_h(wclk,w_en,wrst_n,g_rptr_sync,g_wptr,b_wptr,full);
      rd_ptr_handler #(PTR_WIDTH) rptr_h(rclk,rrst_n,r_en,g_wptr_sync,b_rptr,g_rptr,empty);
      
      async_fifo #(FIFO_WIDTH,PTR_WIDTH)
                  fifo_mem(wclk    ,    rclk,
                           w_en    ,    r_en,
                           b_wptr  ,  b_rptr,
                           full    ,   empty,
                           data_in , data_out
                  );
      
endmodule

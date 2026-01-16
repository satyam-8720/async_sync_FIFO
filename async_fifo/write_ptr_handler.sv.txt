`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: SATYAM
// Create Date: 21.12.2025 19:22:18
// Design Name: 
// Module Name: wrt_ptr_handler
// Project Name: ASYNC FIFO
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module wrt_ptr_handler#(
        parameter PTR_WIDTH = 3
    )(
        input wclk,
        input w_en,
        input wrst_n,
        input [PTR_WIDTH:0] g_rptr_sync,         // synchronized gray read pointer
        output reg[PTR_WIDTH:0] g_wptr,b_wptr,   // gray and binary write pointer 
        output reg full

    );
    
    wire wfull;
    reg [PTR_WIDTH:0] g_wptr_next,b_wptr_next;
    
    assign b_wptr_next = b_wptr + (w_en && !full);             // point to next location when write enable and not full
    assign g_wptr_next = b_wptr_next ^ (b_wptr_next >> 1);    // XOR operation to convert binary to gray code using -- 
                                                              // right shift operation
   
        
      
    always@(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) begin
            g_wptr <= 0;    // set default values
            b_wptr <= 0;
            //full   <= 0;
         end  
        else begin
            b_wptr <= b_wptr_next ;    // increment binary and GRAY write pointer
            g_wptr <= g_wptr_next ;
            //full   <= wfull;
         end
     end
     always@(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            full  <= 0;
         end
        else begin
            full   <= wfull;
         end
      end    
      
      // wfull ie mem full is when write pointer == read pointer with MSB and 2nd MSB inverted       
     assign wfull = (g_wptr_next == {~g_rptr_sync[PTR_WIDTH : PTR_WIDTH-1],g_rptr_sync[PTR_WIDTH-2 :0]});        
           
endmodule

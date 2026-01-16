`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Satyam
// 
// Create Date: 13.12.2025 11:35:36
// Design Name: 
// Module Name: tb_sync_fifo
 
//////////////////////////////////////////////////////////////////////////////////


module tb_sync_fifo;
          parameter FIFO_WIDTH=32;
          parameter FIFO_DEPTH=8;
          reg clk =0;
          reg rst_n =1;
          reg wrt_en =0;
          reg rd_en =0;
          reg cs =0;
          reg [FIFO_WIDTH-1:0] data_in;
          wire [FIFO_WIDTH-1:0] data_out;
          wire full;
          wire empty;
       integer i;
       // clock signal generation
       always #5 clk = ~clk;
     
       //fifo initialisation
       fifo_sync #(FIFO_WIDTH,FIFO_DEPTH)
                  dut(clk   ,   rst_n,
                      wrt_en,   rd_en,
                      cs    ,  data_in,
                      data_out,full,empty);
                      
       // burst write operation 
       task data_write_start(input [FIFO_WIDTH-1:0] d_in);
            begin 
                @(posedge clk);  // synchronize with the clock 
                cs      = 1;
                wrt_en  = 1;
                data_in = d_in;
                $display($time,"data written: %0d, full: %b",d_in,full);
            end
       endtask
       
       task data_write_stop();
            begin
                @(posedge clk);
                cs      = 1;
                wrt_en  = 0;
            end
       endtask
       
       // read operation
       task data_read();
            begin
                @(posedge clk);
                cs   = 1;
                rd_en = 1;
                @(posedge clk);  // delay of 1 clock pulse
                $display($time,"data read :%0d, empty :%b",data_out,empty);
                rd_en = 0; cs = 1;
            end
       endtask 
       
       // create stimulus
       initial
            begin
                #1;
                rst_n =0;rd_en =0; wrt_en =0;
                @(posedge clk)
                rst_n = 1;
                $display($time,"\ncase 1");
                data_write_start(1);
                data_write_start(10);
                data_write_start(100);
                data_write_stop(); // 3 data in fifo
                #5;
                data_read();
                data_read();
                data_read();  // read data
                
                $display($time,"\ncase2");
                for(i=0 ;i <FIFO_DEPTH ; i=i+1)begin
                 data_write_start(2**i);
                 data_write_stop();
                 data_read();
                end
                   
                $display($time,"\ncase3");
                for(i=0 ;i <=FIFO_DEPTH ; i=i+1)begin
                 data_write_start(2**i);
                 data_write_stop();
                end
                
                for(i=0 ;i <FIFO_DEPTH ; i=i+1)begin
                 data_read();
                end
              
              #40 $finish;
              
          end  
                                           
endmodule

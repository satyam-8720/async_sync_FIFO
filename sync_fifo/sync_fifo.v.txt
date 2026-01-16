
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Satyam 
// Create Date: 12.12.2025 15:48:28
// Design Name: 
// Module Name: fifo_sync
// Project Name: sync_fifo
 

//////////////////////////////////////////////////////////////////////////////////


module fifo_sync
                // fifo description
                #(parameter FIFO_WIDTH=32,
                  parameter FIFO_DEPTH=8
                  )
                  (input clk,
                  input rst_n,
                  input wrt_en, 
                  input rd_en,
                  input cs ,//chip select
                  input [FIFO_WIDTH-1:0] data_in,
                  output reg [FIFO_WIDTH-1:0] data_out,
                  output full,
                  output empty 
                 );
                 localparam FIFO_DEPTH_LOG= $clog2(FIFO_DEPTH); //bit size for write and read pointer
                 reg [FIFO_DEPTH_LOG:0]write_pointer;
                 reg [FIFO_DEPTH_LOG:0]read_pointer; // read and write pointer have a extra bit for full signal
                 
                 // fifo_register ie a 2-D array of size 8*(32 bit)
                 reg [FIFO_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];
                 
                 // write operation
                 always @(posedge clk or negedge rst_n)
                    begin
                        if(!rst_n)
                            write_pointer <= 0;
                        else if(cs && wrt_en && !full)
                            begin
                                fifo[write_pointer[FIFO_DEPTH_LOG-1:0]] <= data_in;
                                write_pointer <= write_pointer + 1'b1 ;
                            end
                    end
                    
                  // read operation
                  always @(posedge clk or negedge rst_n)
                    begin
                        if(!rst_n)
                            read_pointer <= 0;
                        else if(cs && rd_en && !empty)
                            begin
                                data_out <= fifo[read_pointer[FIFO_DEPTH_LOG-1:0]] ;
                                read_pointer <= read_pointer + 1'b1 ;
                            end
                    end
                    
                   // full and empty signal
                   assign empty = (read_pointer == write_pointer);
                   assign full =  (read_pointer == {~write_pointer[FIFO_DEPTH_LOG],write_pointer[FIFO_DEPTH_LOG-1:0]});  // write pointer          1000 for depth 8
                   
endmodule

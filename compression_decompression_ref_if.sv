interface compression_decompression_ref_if(input logic clk, input logic reset);
  logic [1:0] command;
  logic [79:0] data_in;
  logic [7:0] compressed_in;
  logic [7:0] compressed_out;
  logic [79:0] decompressed_out;
  logic [1:0] response;
endinterface

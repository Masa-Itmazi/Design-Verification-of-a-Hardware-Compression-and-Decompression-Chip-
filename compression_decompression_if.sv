// interface compression_decompression_if(input logic clk, input logic reset);

//   logic [1:0] command;
//   logic [79:0] data_in;
//   logic [7:0] compressed_in;
//   logic [7:0] compressed_out;
//   logic [79:0] decompressed_out;
//   logic [1:0] response;
  
//   //all the required DUT interfaces as logic values (either 0 or 1)

// endinterface


interface compression_decompression_if(input logic clk, input logic reset);
  // Clock and reset signals
  logic clk;
  logic reset;

  // Input signals
  logic [1:0] command;
  logic [79:0] data_in;
  logic [7:0] compressed_in;

  // Output signals
  logic [7:0] compressed_out;
  logic [79:0] decompressed_out;
  logic [1:0] response;

  // Define clocking block for clock and reset
  clocking cb @(posedge clk, posedge reset);
    input reset;
  endclocking

  // Define modport for driver and monitor communication
//   modport dut_modport (
//     input clk, reset,
//     input command, data_in, compressed_in,
//     output compressed_out, decompressed_out, response
//   );

endinterface

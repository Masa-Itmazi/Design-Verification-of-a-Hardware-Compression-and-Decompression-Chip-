 import uvm_pkg::*;
`include "uvm_macros.svh"
`include "compression_decompression_if.sv"
`include "comp_decomp_ref_if.sv"
`include "compression_decompression.sv"
`include "reference_model.sv"
// `include "no_operation_test.sv"
// `include "random_tests.sv"
`include "comp_dec_test.sv"

module tb_top();

  // Clock and reset signals
  logic clk;
  logic reset;

  // Real interface instance
  compression_decompression_if if_inst (clk, reset);
// Real interface instance for Reference Model
  compression_decompression_ref_if ref_if_inst (clk, reset);

  // Virtual interface
  virtual compression_decompression_if dut_if;
  virtual compression_decompression_ref_if ref_if;


  // DUT instance
  compression_decompression #(
    .DICTIONARY_DEPTH(1)
  ) dut (
    .clk(clk),
    .reset(reset),
    .command(if_inst.command),
    .data_in(if_inst.data_in),
    .compressed_in(if_inst.compressed_in),
    .compressed_out(if_inst.compressed_out),
    .decompressed_out(if_inst.decompressed_out),
    .response(if_inst.response)
  );
  
  // Reference Model instance
  compression_decompression_ref_model #(
    .DICTIONARY_DEPTH(1)
  ) ref_model (
    .clk(clk),
    .reset(reset),
    .command(ref_if_inst.command),
    .data_in(ref_if_inst.data_in),
    .compressed_in(ref_if_inst.compressed_in),
    .compressed_out(ref_if_inst.compressed_out),
    .decompressed_out(ref_if_inst.decompressed_out),
    .response(ref_if_inst.response)
  );

  // Assign virtual interface
  initial begin
    dut_if = if_inst;
    ref_if = ref_if_inst;
    uvm_config_db#(virtual compression_decompression_if)::set(uvm_root::get(), "*", "dut_if", dut_if);
    uvm_config_db#(virtual compression_decompression_ref_if)::set(uvm_root::get(), "*", "ref_if", ref_if);
  end

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100 MHz clock
  end

  // Reset generation
  initial begin
    #10reset = 1;
    #20 reset = 0;
  end

  // Dump waveform
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

  // Run the test
  initial begin
    run_test("comp_dec_test");
  end
  
  // Virtual interface configuration
  initial begin
    uvm_config_db#(virtual compression_decompression_if)::set(null, "e.agt.mon", "dut_if", dut_if);
     uvm_config_db#(virtual compression_decompression_ref_if)::set(null, "e.agt.mon", "ref_if", ref_if);
    uvm_config_db#(virtual compression_decompression_if)::set(null, "e.cov_collector", "dut_if", dut_if);

  end
  
endmodule

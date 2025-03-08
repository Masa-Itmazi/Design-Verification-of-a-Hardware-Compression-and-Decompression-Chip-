`include "uvm_macros.svh"
`include "base_test.sv"

class comp_dec_test extends base_test;

  `uvm_component_utils(comp_dec_test)

  function new(string name = "comp_dec_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Override the run_test_sequence method from the base test
  virtual task run_test_sequence();
    compress_decompress_sequence seq;
    uvm_report_info("comp_dec_test", "Starting compression --> decompression sequence", UVM_MEDIUM);

    // Create and start the sequence
    seq = compress_decompress_sequence::type_id::create("seq");
    seq.start(test_env.agt.sqr);

    // Wait for test completion
    #200; // Adjust as necessary

    uvm_report_info("comp_dec_test", "Completed comp_dec_test sequence", UVM_MEDIUM);
  endtask

endclass

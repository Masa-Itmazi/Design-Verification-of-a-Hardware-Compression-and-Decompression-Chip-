`include "uvm_macros.svh"
`include "base_test.sv"

class random_test extends base_test;

  `uvm_component_utils(random_test)

  function new(string name = "random_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Override the run_test_sequence method from the base test
  virtual task run_test_sequence();
    test_sequence seq;
    uvm_report_info("test_sequence", "Starting compression --> test sequence", UVM_MEDIUM);

    // Create and start the sequence
    seq = test_sequence::type_id::create("seq");
    seq.start(test_env.agt.sqr);

    // Wait for test completion
    uvm_report_info("test_sequence", "Completed test sequence", UVM_MEDIUM);
  endtask

endclass

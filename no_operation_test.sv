`include "uvm_macros.svh"
`include "base_test.sv"

class no_operation_test extends base_test;

  `uvm_component_utils(no_operation_test)

  function new(string name = "no_operation_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Override the run_test_sequence method from the base test
  virtual task run_test_sequence();
    no_op_sequence seq;
    uvm_report_info("no_operation_test", "Starting no_operation_test sequence", UVM_MEDIUM);

    // Create and start the sequence
    seq = no_op_sequence::type_id::create("seq");
    seq.start(test_env.agt.sqr);

    // Wait for test completion
    #100; // Adjust as necessary

    uvm_report_info("no_operation_test", "Completed no_operation_test sequence", UVM_MEDIUM);
  endtask

endclass

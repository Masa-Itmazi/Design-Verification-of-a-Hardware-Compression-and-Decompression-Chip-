`include "uvm_macros.svh"
`include "env.sv"

class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  env test_env;

  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    test_env = env::type_id::create("test_env", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    uvm_report_info("base_test", "Starting base test run phase", UVM_MEDIUM);
    phase.raise_objection(this);

    // Placeholder for derived class specific sequences
    run_test_sequence();

    phase.drop_objection(this);
    uvm_report_info("base_test", "Completed base test run phase", UVM_MEDIUM);
  endtask

  virtual task run_test_sequence();
    // To be overridden by derived classes
  endtask

endclass

// `include "sequence.sv"
//we add any specific sequence include here
// `include "no_op_seq.sv"
`include "comp_dec_seq.sv"
`include "agent.sv"

class env extends uvm_env;
  `uvm_component_utils(env)
  agent agt;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = agent::type_id::create("agt", this);
  endfunction
  
endclass

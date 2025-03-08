`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  driver drv;
  monitor mon;
  sequencer sqr;
  scoreboard sb; // Adding the scoreboard
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv = driver::type_id::create("drv", this);
    mon = monitor::type_id::create("mon", this);
    sqr = sequencer::type_id::create("sqr", this);
    sb = scoreboard::type_id::create("sb", this); // Creating the scoreboard

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
    mon.item_collected_port.connect(sb.dut_item_collected_imp); // Connecting monitor to scoreboard
    mon.item_collected_port_ref.connect(sb.ref_item_collected_imp);
  endfunction
endclass

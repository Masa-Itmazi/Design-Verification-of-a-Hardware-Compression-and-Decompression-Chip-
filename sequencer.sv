class sequencer extends uvm_sequencer #(transaction);// a basic sequencer

  `uvm_component_utils(sequencer)

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

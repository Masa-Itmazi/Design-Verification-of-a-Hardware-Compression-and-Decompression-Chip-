class driver extends uvm_driver #(transaction);

  `uvm_component_utils(driver)

  virtual compression_decompression_if dut_if;
  virtual compression_decompression_ref_if ref_if;

  transaction req;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual compression_decompression_if) :: get(this, " ", "dut_if", dut_if))
      `uvm_fatal("", "Failed to get intf from config db");
 if (!uvm_config_db #(virtual compression_decompression_ref_if) :: get(this, "", "ref_if", ref_if))
      `uvm_fatal("", "Failed to get ref_if from config db");
    req = new();
  endfunction

  virtual task run_phase(uvm_phase phase);
    fork
      forever begin
          seq_item_port.get_next_item(req);
          drive(req);
          seq_item_port.item_done();
      end
    join
  endtask

  task drive(transaction item);
    @(posedge dut_if.clk);
    dut_if.command <= item.command;
    dut_if.data_in <= item.data_in;
    dut_if.compressed_in <= item.compressed_in;
    //ref_if also should take the data at each clock
	ref_if.command <= item.command;
    ref_if.data_in <= item.data_in;
    ref_if.compressed_in <= item.compressed_in;
  endtask

endclass

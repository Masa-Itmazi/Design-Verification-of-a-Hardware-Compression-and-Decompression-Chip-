class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  // Analysis ports to connect to monitor and reference model
  uvm_analysis_imp#(transaction, scoreboard) dut_item_collected_imp;
  uvm_blocking_put_imp#(transaction, scoreboard) ref_item_collected_imp;
  
  
  transaction dut_trans = new();
  transaction ref_trans = new();


  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_item_collected_imp = new("dut_item_collected_imp", this);
    ref_item_collected_imp = new("ref_item_collected_imp", this);
  endfunction
  
  // Override the write function to process received transactions
  virtual function void write(transaction data);
    dut_trans = data;
  endfunction
  
  virtual function void put(transaction data);
    ref_trans = data;
    
  endfunction

  //just build a run_phase that just prints the contents of ref_trans and dut_trans
  // Task to print contents of dut_trans and ref_trans
 virtual task run_phase(uvm_phase phase);
  transaction last_dut_trans;
  transaction last_ref_trans;
  
  // Initialize last transactions to null or default values
  last_dut_trans = null;
  last_ref_trans = null;

  forever begin
    // Check if both DUT and reference model transactions are not null
    if (dut_trans != null && ref_trans != null) begin
      // Compare DUT and reference model transactions
      if (!dut_trans.compare(ref_trans)) begin
        // Print DUT transaction
        `uvm_info("scoreboard", $sformatf("DUT Transaction: Command = %0d, Data = %0h, compressed_in = %0d, compressed_out = %0d, decompressed_out = %0h, response = %0d", 
                                          dut_trans.command, dut_trans.data_in, dut_trans.compressed_in,
                                          dut_trans.compressed_out, dut_trans.decompressed_out, dut_trans.response), UVM_MEDIUM)
        // Print reference model transaction
        `uvm_info("scoreboard", $sformatf("Reference Model Transaction: Command = %0d, Data = %0h, compressed_in = %0d, compressed_out = %0d, decompressed_out = %0h, response = %0d", 
                                          ref_trans.command, ref_trans.data_in, ref_trans.compressed_in,
                                          ref_trans.compressed_out, ref_trans.decompressed_out, ref_trans.response), UVM_MEDIUM)
        
        // Update last transactions
        last_dut_trans = dut_trans;
        last_ref_trans = ref_trans;
      end
      else
        begin
        `uvm_info("scoreboard", "Transactions Match: Pass", UVM_MEDIUM)
        end
    end

    // Optionally add delay to control simulation speed
    #10; // Adjust delay as per simulation requirements
  end
endtask


endclass

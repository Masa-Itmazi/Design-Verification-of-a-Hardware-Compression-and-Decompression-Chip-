class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  virtual compression_decompression_if dut_if;
  virtual compression_decompression_ref_if ref_if;

  
  
  uvm_analysis_port #(transaction) item_collected_port;//for the dut
  uvm_blocking_put_port#(transaction) item_collected_port_ref;  // Port for reference model transactions


  // Placeholder to capture transaction information.
  transaction trans_collected;
  transaction trans_collected_ref;

  // File handle for output file
  integer file;
  integer ref_file;


  covergroup my_covergroup;
    option.per_instance = 1;

    command_cp : coverpoint dut_if.command {
      bins no_operation = {2'b00};
      bins compression = {2'b01};
      bins decompression = {2'b10};
      bins invalid_command = {2'b11};
    }

    compressed_in_cp : coverpoint dut_if.compressed_in {
      bins valid_data = {[0:255]}; // Valid compressed data range
    }

    compressed_out_cp : coverpoint dut_if.compressed_out {
      bins success = {[0:255]}; // Successful compression
    }

    decompressed_out_cp : coverpoint dut_if.decompressed_out {
      bins valid_data = {[0:255]}; // Valid decompressed data range
    }

    response_cp : coverpoint dut_if.response {
      bins success_1 = {2'b01}; // Successful response
      bins success_2 = {2'b10}; // Successful response
      bins failure = {2'b11}; // Failure response
    }

    // Cross Coverage
    command_data_cp : cross dut_if.command, dut_if.data_in;
  endgroup

  function new(string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = new();
    trans_collected_ref = new();
    item_collected_port = new("item_collected_port", this);
    item_collected_port_ref = new("item_collected_port_ref", this);

    my_covergroup = new();
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual compression_decompression_if)::get(this, "", "dut_if", dut_if))
      `uvm_fatal(" ", "Failed to get intf from config db");
 if (!uvm_config_db#(virtual compression_decompression_ref_if)::get(this, "", "ref_if", ref_if))
      `uvm_fatal(" ", "Failed to get ref_if from config db");

    // Open file for writing
    file = $fopen("dut.txt", "w");
    if (file == 0) begin
      `uvm_fatal("FILE", "Failed to open file dut.txt");
    end
    
    ref_file = $fopen("ref.txt", "w");
    if (ref_file == 0) begin
      `uvm_fatal("FILE", "Failed to open file ref.txt");
    end
  endfunction

  virtual function void finalize_phase(uvm_phase phase);
    // Close file
    if (file != 0) begin
      $fclose(file);
    end
    if (ref_file != 0) begin
      $fclose(ref_file);
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge dut_if.clk);
      wait(dut_if.command != 2'b00); // Wait until a command other than NOP is issued

      trans_collected.command = dut_if.command;
      trans_collected.data_in = dut_if.data_in;
      trans_collected.compressed_in = dut_if.compressed_in;
      
      //also fill the transaction for the reference model
      trans_collected_ref.command = ref_if.command;
      trans_collected_ref.data_in = ref_if.data_in;
      trans_collected_ref.compressed_in = ref_if.compressed_in;
      

      @(posedge dut_if.clk); // Capture data after command is issued

      if (dut_if.command == 2'b01) begin // Compression
        trans_collected.compressed_out = dut_if.compressed_out;
        
        trans_collected_ref.compressed_out = ref_if.compressed_out;

      end else if (dut_if.command == 2'b10) begin // Decompression
        trans_collected.decompressed_out = dut_if.decompressed_out;
        trans_collected_ref.decompressed_out = ref_if.decompressed_out;

      end

      trans_collected.response = dut_if.response;
      trans_collected_ref.response = ref_if.response;


      item_collected_port.write(trans_collected);
      item_collected_port_ref.put(trans_collected_ref);


      // Write monitored signals to file in CSV format
      $fwrite(file, "%0d,%0h,%0h,%0h,%0h,%0d\n",
              dut_if.command,
              dut_if.data_in,
              dut_if.compressed_in,
              dut_if.compressed_out,
              dut_if.decompressed_out,
              dut_if.response);
      
      $fwrite(ref_file, "%0d,%0h,%0h,%0h,%0h,%0d\n",
              ref_if.command,
              ref_if.data_in,
              ref_if.compressed_in,
              ref_if.compressed_out,
              ref_if.decompressed_out,
              ref_if.response);

      // Display monitored signals with formatted output
      $display("===============================");
      $display("|          Monitor           |");
      $display("===============================");
      $display("| Command          : %0d    |", dut_if.command);
      $display("| Data In          : %0h    |", dut_if.data_in);
      $display("| Compressed In    : %0h    |", dut_if.compressed_in);
      $display("| Compressed Out   : %0h    |", dut_if.compressed_out);
      $display("| Decompressed Out : %0h    |", dut_if.decompressed_out);
      $display("| Response         : %0d    |", dut_if.response);
      $display("===============================");

      // Sample coverage
      my_covergroup.sample();

      // Display coverage percentage
      $display("Coverage = %0.2f %%", my_covergroup.get_inst_coverage());
//       $display("");
    end
  endtask

endclass

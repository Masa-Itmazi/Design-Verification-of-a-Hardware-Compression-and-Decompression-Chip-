class transaction extends uvm_sequence_item;

  // Define the inputs
  typedef enum logic [1:0] {
    CMD_NOP = 2'b00,
    CMD_COMPRESS = 2'b01,
    CMD_DECOMPRESS = 2'b10,
    CMD_INVALID = 2'b11
  } command_e;

  rand command_e command;
  rand logic [79:0] data_in;
  rand logic [7:0] compressed_in;

  // Output/result fields
  logic [7:0] compressed_out;
  logic [79:0] decompressed_out;
  logic [1:0] response;

  // UVM automation macros
  `uvm_object_utils_begin(transaction)
    `uvm_field_enum(command_e, command, UVM_ALL_ON)
    `uvm_field_int(data_in, UVM_ALL_ON)
    `uvm_field_int(compressed_in, UVM_ALL_ON)
    `uvm_field_int(compressed_out, UVM_ALL_ON)
    `uvm_field_int(decompressed_out, UVM_ALL_ON)
    `uvm_field_int(response, UVM_ALL_ON)
  `uvm_object_utils_end

  // Constraints
  constraint valid_command { command inside {CMD_NOP, CMD_COMPRESS, CMD_DECOMPRESS, CMD_INVALID}; }
  constraint data_in_range { data_in inside {[0:79]}; }
  constraint compressed_in_range { compressed_in inside {[0:255]}; }

  // Constructor
  function new(string name = "transaction");
    super.new(name);
  endfunction

  // Display function for debug purposes
  virtual function void display();
    $display("command: %0d, data_in: %0h, compressed_in: %0h, compressed_out: %0h, decompressed_out: %0h, response: %0d",
              command, data_in, compressed_in, compressed_out, decompressed_out, response);
  endfunction
  
   function bit compare(transaction other);
    // Compare each field of the transaction
    if (this.command !== other.command) return 0;
    if (this.data_in !== other.data_in) return 0;
    if (this.compressed_in !== other.compressed_in) return 0;
    if (this.compressed_out !== other.compressed_out) return 0;
    if (this.decompressed_out !== other.decompressed_out) return 0;
    if (this.response !== other.response) return 0;

    // If all fields match, return 1 (true)
    return 1;
  endfunction
endclass

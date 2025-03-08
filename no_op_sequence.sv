`include "transaction.sv"

class no_op_sequence extends uvm_sequence #(transaction);

  `uvm_object_utils(no_op_sequence)

  // Constructor
  function new(string name = "no_op_sequence");
    super.new(name);
  endfunction

  // Sequence body
  virtual task body();
    transaction tx;
    repeat (1) begin
      tx = transaction::type_id::create("tx");
      start_item(tx);

      // Set the command to no_op
      tx.command = transaction::CMD_NOP;
      tx.data_in = 80'h77;  // Optional, can set to any value
      tx.compressed_in = 8'h0;  // Optional, can set to any value
      //wait a bit, then we test the reset
      

      // Finish the transaction
      finish_item(tx);
    end
  endtask

endclass

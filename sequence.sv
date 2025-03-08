`include "transaction.sv"

class test_sequence extends uvm_sequence #(transaction);

  `uvm_object_utils(test_sequence)

  // Constructor
  function new(string name = "test_sequence");
    super.new(name);
  endfunction

  // Sequence body
  virtual task body();
    transaction tx;
    repeat (20) begin // Generate 10 transactions
      tx = transaction::type_id::create("tx");
      start_item(tx);

      // Randomize the transaction
      assert(tx.randomize());

      // Finish the transaction
      finish_item(tx);
    end
  endtask

endclass

`include "transaction.sv"

class compress_decompress_sequence extends uvm_sequence #(transaction);

  `uvm_object_utils(compress_decompress_sequence)

  // Constructor
  function new(string name = "compress_decompress_sequence");
    super.new(name);
  endfunction

  // Sequence body
  virtual task body();
    transaction tx;
    bit [7:0] compressed_data;

    // Step 1: Compress the string
//     tx = transaction::type_id::create("tx_compress");
//     start_item(tx);

//     tx.command = transaction::CMD_COMPRESS;
//     tx.data_in = 80'h123456789ABCDEF12345;  // Example data to be compressed
//     tx.compressed_in = 8'h0;  // Not used in compression

//     // Finish the compression transaction
//     finish_item(tx);

//     // Capture the compressed output for decompression
//     compressed_data = tx.compressed_out;

//     // Display the compression transaction for debug purposes
//     tx.display();

    // Introduce a delay before decompression
    #50;  // Delay of 50 time units, adjust as necessary

    // Step 2: Decompress the string
    tx = transaction::type_id::create("tx_decompress");
    start_item(tx);

    tx.command = transaction::CMD_DECOMPRESS;
    tx.data_in = 80'h0;  // Not used in decompression
    tx.compressed_in = compressed_data;

    // Finish the decompression transaction
    finish_item(tx);

    // Display the decompression transaction for debug purposes
    tx.display();
    // Step 1: Compress the string
    tx = transaction::type_id::create("tx_compress");
    start_item(tx);

    tx.command = transaction::CMD_COMPRESS;
    tx.data_in = 80'h123456789FFFFF12345;  // Example data to be compressed
    tx.compressed_in = 8'h0;  // Not used in compression

    // Finish the compression transaction
    finish_item(tx);

    // Capture the compressed output for decompression
    compressed_data = tx.compressed_out;

    // Display the compression transaction for debug purposes
    tx.display();

    // Introduce a delay before decompression
    #100;  // Delay of 50 time units, adjust as necessary

    // Step 2: Decompress the string
    tx = transaction::type_id::create("tx_decompress");
    start_item(tx);

    tx.command = transaction::CMD_DECOMPRESS;
    tx.data_in = 80'h0;  // Not used in decompression
    tx.compressed_in = 5;

    // Finish the decompression transaction
    finish_item(tx);

    // Display the decompression transaction for debug purposes
    tx.display();
        // Step 3: Perform CMD_INVALID command
    tx = transaction::type_id::create("tx_invalid");
    start_item(tx);

    tx.command = transaction::CMD_INVALID;
    tx.data_in = 80'h0;  // Not used in CMD_INVALID
    tx.compressed_in = 8'h0;  // Not used in CMD_INVALID

    // Finish the transaction with CMD_INVALID
    finish_item(tx);

  endtask

endclass

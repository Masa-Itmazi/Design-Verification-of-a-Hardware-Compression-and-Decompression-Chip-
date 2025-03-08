# Design-Verification-of-a-Hardware-Compression-and-Decompression-Chip-
This project verifies a dictionary-based compression and decompression chip using UVM. It includes a reference model, verification plan, and a complete UVM testbench to ensure functional correctness and coverage.
## Key Features:
Compression Algorithm: Matches input data with stored dictionary entries and outputs an 8-bit compressed index.
Decompression Algorithm: Retrieves original data using the stored dictionary based on compressed indices.
Error Handling: Reports errors when the dictionary is full (compression) or an invalid index is received (decompression).
Verification Approach: Implements Universal Verification Methodology (UVM) for functional verification, ensuring correctness and coverage.
## Project Structure:
Reference Model: Defines expected chip behavior.
Verification Plan: Outlines test scenarios and coverage goals.
UVM Testbench: A complete test environment with assertions, coverage collection, and simulation results.

# Uni project consisting of two Verilog programs: (38, 32) Hamming code, and (8, 3) Hadamard code.

## First program - (38, 32) Hamming Code implementation:
### 1st module (Encoder):
Codes 32 bit messages into codewords by calculating 6 parity bits and inserting them at the positions of powers of two. Other positions are filled with information bits of the initial message.
### 2nd module:
Loads 38 bit codewords that left the encoder but all codewords have least singnificant bit inverted by xor operation. After that, syndrome bits are calculated, and error detection and correction is done with the usage of „blad_poz” array, that consists of all (6) calculated syndrome bits. At the end of this module, corrected 38 bit codewords, and 32 bit decoded messages are shown. 

### 3rd module (testbench): 
Executes every functionality from previous modules for a number of iterations specified in the for loop. All signals are saved to the „wyniki_hamming.vcd” file. Signals can be read with gtkwave.

## Second program - (8, 3) Hadamard Code implementation:
### 1st module (Encoder):
Codes 3 bit messages into 8 bit codewords by XOR multiplication of generator matrix rows by 3 bit messages.
### 2nd module: 
Counts the difference between 8 bit codewords with a single-bit error and the rows of the code word matrix. The row, for which difference is the smallest, is the corrected output 8 bit codeword. Decoding 8 bit code words to 3 bit messages is done by switch statements xd
### 3rd module (testbench): 
Executes every functionality from previous modules for a number of iterations specified in the for loop. All signals are saved to the „wyniki_hadamarda.vcd” file. Signals can be read with gtkwave.

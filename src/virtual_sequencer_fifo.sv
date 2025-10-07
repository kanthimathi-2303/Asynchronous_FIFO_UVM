//`include "uvm_macros.svh"
//import uvm_pkg::*;
//`include "write_sequencer_fifo.sv"
//`include "read_sequencer_fifo.sv"

class virtual_sequencer extends uvm_sequencer;
   write_sequencer wr_seqr;
   read_sequencer  rd_seqr;
   
   function new(string name = "virtual_sequencer", uvm_component parent);
      super.new(name, parent);
   endfunction 
   
   `uvm_component_utils(virtual_sequencer)
endclass

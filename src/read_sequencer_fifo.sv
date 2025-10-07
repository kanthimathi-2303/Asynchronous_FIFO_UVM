//`include "uvm_macros.svh"
//import uvm_pkg::*;
//`include "read_sequence_item_fifo.sv"

class read_sequencer extends uvm_sequencer #(read_sequence_item);

	function new(string name = "read_sequencer", uvm_component parent);
		super.new(name, parent);
	endfunction 

	`uvm_component_utils(read_sequencer)
endclass

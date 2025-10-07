//`include "uvm_macros.svh"
//import uvm_pkg::*;
//`include "write_sequence_item_fifo.sv"

class write_sequencer extends uvm_sequencer #(write_sequence_item);

	function new(string name = "write_sequencer_fifo", uvm_component parent);
		super.new(name, parent);
	endfunction

	`uvm_component_utils(write_sequencer)
endclass

/*`include "uvm_macros.svh"
import uvm_pkg::*;
`include "environment_fifo.sv"
*/
class base_test extends uvm_test;
	`uvm_component_utils(base_test)

	environment env;

	function new(string name = "base_test",uvm_component parent );
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = environment::type_id::create("env",this);
	endfunction

  task run_phase(uvm_phase phase);
    virtual_sequence vseq;
    phase.raise_objection(this);

    `uvm_info(get_type_name(), "Starting FIFO test", UVM_LOW)

    vseq = virtual_sequence::type_id::create("vseq");

    vseq.vseqr = env.vseqr;

    vseq.start(env.vseqr);

    phase.drop_objection(this);
  endtask

	virtual function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction

endclass


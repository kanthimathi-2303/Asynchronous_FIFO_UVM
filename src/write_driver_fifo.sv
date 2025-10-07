/*`include "uvm_macros.svh"
import uvm_pkg::*;
`include "defines_fifo.sv"
`include "write_sequence_item_fifo.sv"
*/
class write_driver extends uvm_driver#(write_sequence_item);
	virtual if_fifo vif;

	`uvm_component_utils(write_driver)

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db#(virtual if_fifo)::get(this,"","vif",vif))
			`uvm_fatal("NO_VIF",{"virtual intrface must be set for:",get_full_name(),".vif"});
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		@(vif.wdrv_cb);
		forever begin
			seq_item_port.get_next_item(req);
			drive(req);
			seq_item_port.item_done();
		end
	endtask

	task drive(write_sequence_item item);
				vif.winc  <= item.winc;
				vif.wdata <= item.wdata;
		`uvm_info(get_type_name(),$sformatf("[%0t] Driving Write: winc=%0b, wdata=%0d",$time,vif.winc,vif.wdata),UVM_LOW);
		@(vif.wdrv_cb);

	endtask

endclass

/*`include "uvm_macros.svh"
import uvm_pkg::*;
`include "defines_fifo.sv"
`include "read_sequence_item_fifo.sv"
*/
class read_driver extends uvm_driver#(read_sequence_item);
        virtual if_fifo vif;
        logic no_tr = 1'b0;

        `uvm_component_utils(read_driver)

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
					@(vif.rdrv_cb);
					forever begin
						seq_item_port.get_next_item(req);
						drive(req);
						seq_item_port.item_done();
					end
				endtask


				task drive(read_sequence_item item);
							vif.rinc <= item.rinc;
					`uvm_info(get_type_name(),$sformatf("[%0t] Driving Read: rinc=%0d",$time,vif.rinc),UVM_LOW)
					@(vif.rdrv_cb);

				endtask

endclass

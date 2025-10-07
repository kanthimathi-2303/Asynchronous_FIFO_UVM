/*`include "uvm_macros.svh"
import uvm_pkg::*;
`include "defines_fifo.sv"
`include "write_sequence_item_fifo.sv"
*/
class write_monitor extends uvm_monitor;
  virtual if_fifo vif;
  uvm_analysis_port #(write_sequence_item) wr_ap;

  `uvm_component_utils(write_monitor)

  function new(string name = "write_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual if_fifo)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", { "virtual interface must be set for: ", get_full_name(), ".vif" });
    wr_ap = new("ap", this);
  endfunction

  task run_phase(uvm_phase phase);
    write_sequence_item tr;
		repeat(2)@(vif.wmon_cb);
    forever begin
      tr = write_sequence_item::type_id::create("tr", this);
      collect_one_pkt(tr);
      wr_ap.write(tr);
    end
  endtask

  task collect_one_pkt(write_sequence_item tr);
		tr.winc = vif.winc;
    tr.wdata = vif.wdata;
		tr.wfull = vif.wfull;
		`uvm_info(get_type_name(),$sformatf("[%0t] Write Monitor: winc=%0b , wdata=%0d, wfull=%0d",$time,tr.winc,tr.wdata,tr.wfull),UVM_LOW)
		@(vif.wmon_cb);
  endtask
endclass


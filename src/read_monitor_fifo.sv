/*`include "uvm_macros.svh"
import uvm_pkg::*;
`include "defines_fifo.sv"
`include "read_sequence_item_fifo.sv"
*/
class read_monitor extends uvm_monitor;
  virtual if_fifo vif;
  uvm_analysis_port #(read_sequence_item) rd_ap;

  `uvm_component_utils(read_monitor)

  function new(string name = "read_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual if_fifo)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", { "virtual interface must be set for: ", get_full_name(), ".vif" });
    rd_ap = new("ap", this);
  endfunction


  task run_phase(uvm_phase phase);
    read_sequence_item tr;
    repeat(2)@(vif.rmon_cb);
    forever begin
      tr = read_sequence_item::type_id::create("tr", this);
      collect_one_pkt(tr);
      rd_ap.write(tr);
    end
  endtask

  task collect_one_pkt(read_sequence_item tr);
		tr.rinc = vif.rinc;
    tr.rdata = vif.rdata;
		tr.rempty = vif.rempty;
		`uvm_info(get_type_name(),$sformatf("[%0t] Read Monitor: rinc=%0b , rdata=%0d, rempty=%0d",$time,tr.rinc,tr.rdata,tr.rempty),UVM_LOW)
		@(vif.rmon_cb);
  endtask
endclass


/*`include "uvm_macros.svh"
import uvm_pkg::*;
`include "read_driver_fifo.sv"
`include "read_monitor_fifo.sv"
`include "read_sequencer_fifo.sv"
*/
class read_agent extends uvm_agent;
  `uvm_component_utils(read_agent)

  read_sequencer sqr;
  read_driver    drv;
  read_monitor   mon;

  uvm_analysis_port #(read_sequence_item) ap;

  function new(string name = "read_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr = read_sequencer::type_id::create("sqr", this);
    drv = read_driver::type_id::create("drv", this);
    mon = read_monitor::type_id::create("mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
    ap = mon.rd_ap; // forward monitor port
  endfunction
endclass

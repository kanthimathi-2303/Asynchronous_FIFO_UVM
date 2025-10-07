/*`include "uvm_macros.svh"
import uvm_pkg::*;
`include "write_driver_fifo.sv"
`include "write_monitor_fifo.sv"
`include "write_sequencer_fifo.sv"
*/
class write_agent extends uvm_agent;
  `uvm_component_utils(write_agent)

  write_sequencer sqr;
  write_driver    drv;
  write_monitor   mon;

  uvm_analysis_port #(write_sequence_item) ap;

  function new(string name = "write_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr = write_sequencer::type_id::create("sqr", this);
    drv = write_driver::type_id::create("drv", this);
    mon = write_monitor::type_id::create("mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
    ap = mon.wr_ap; // forward monitor port
  endfunction
endclass

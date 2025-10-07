/*`include "uvm_macros.svh"
import uvm_pkg::*;
`include "write_agent_fifo.sv"
`include "read_agent_fifo.sv"
`include "write_sequencer_fifo.sv"
`include "read_sequencer_fifo.sv"
`include "virtual_sequencer_fifo.sv"
`include "scoreboard_fifo.sv"
`include "subscriber_fifo.sv"
*/
class environment extends uvm_env;
  write_agent      wr_agt;
	read_agent			 rd_agt;
	virtual_sequencer vseqr;
  scoreboard 			 scb;
  subscriber 			 fcov;
  
  `uvm_component_utils(environment)
  
  function new(string name = "environment", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    wr_agt = write_agent::type_id::create("write_agt", this);
    rd_agt = read_agent::type_id::create("read_agt", this);
		vseqr  = virtual_sequencer::type_id::create("vseqr",this);
    scb    = scoreboard::type_id::create("scb", this);
    fcov   = subscriber::type_id::create("fcov", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    wr_agt.ap.connect(scb.wr_sb_fifo.analysis_export);
    rd_agt.ap.connect(scb.rd_sb_fifo.analysis_export);
    wr_agt.ap.connect(fcov.wr_mon_fifo.analysis_export);
    rd_agt.ap.connect(fcov.rd_mon_fifo.analysis_export);

		vseqr.wr_seqr = wr_agt.sqr;
		vseqr.rd_seqr = rd_agt.sqr;
  endfunction

endclass


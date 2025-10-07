/*`include "uvm_macros.svh"
import uvm_pkg::*;
`include "read_sequence_item_fifo.sv"
`include "write_sequence_item_fifo.sv"
*/
class subscriber extends uvm_component;
	`uvm_component_utils(subscriber)

	read_sequence_item rd_mon_trans;
	write_sequence_item wr_mon_trans;

	real rd_mon_cov,wr_mon_cov;

	uvm_tlm_analysis_fifo #(read_sequence_item) rd_mon_fifo;
	uvm_tlm_analysis_fifo #(write_sequence_item) wr_mon_fifo;

	covergroup rd_cg;
		//read coverpoints
		read_inc: coverpoint rd_mon_trans.rinc{bins rd_inc[]={0,1};}
		read_data: coverpoint rd_mon_trans.rdata{
			bins low_rdata  = {[0:63]};
			bins mid_rdata  = {[64:127]};
			bins high_rdata = {[128:255]};
		}
		read_empty: coverpoint rd_mon_trans.rempty{bins r_empty[]={0,1};}
	endgroup

	covergroup wr_cg;
		//write coverpoints
		write_inc: coverpoint wr_mon_trans.winc{bins wr_inc[]={0,1};}
		write_data: coverpoint wr_mon_trans.wdata{
			bins low_wdata  = {[0:63]};
			bins mid_wdata  = {[64:127]};
			bins high_wdata = {[128:255]};
		}
		write_full: coverpoint wr_mon_trans.wfull{bins w_full[]={0,1};}
	endgroup

	function new(string name="subscriber", uvm_component parent=null);
		super.new(name, parent);
		rd_mon_fifo = new("rd_mon_fifo", this);
		wr_mon_fifo = new("wr_mon_fifo", this);
		rd_cg = new;
		wr_cg = new;
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			rd_mon_fifo.get(rd_mon_trans);
			rd_cg.sample();
			wr_mon_fifo.get(wr_mon_trans);
			wr_cg.sample();
		end
	endtask

	function void extract_phase(uvm_phase phase);
		super.extract_phase(phase);
		rd_mon_cov = rd_cg.get_coverage();
		wr_mon_cov = wr_cg.get_coverage();
	endfunction

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_type_name(), $sformatf("[READ] Coverage : %0.2f%%", rd_mon_cov), UVM_MEDIUM);
		`uvm_info(get_type_name(), $sformatf("[WRITE] Coverage : %0.2f%%", wr_mon_cov), UVM_MEDIUM);
	endfunction 

endclass


/*`include "uvm_macros.svh"
import uvm_pkg::*;
`include "defines_fifo.sv"
`include "write_sequence_fifo.sv"
`include "read_sequence_fifo.sv"
`include "virtual_sequencer_fifo.sv"
*/
class virtual_sequence extends uvm_sequence;
  `uvm_object_utils(virtual_sequence)
	`uvm_declare_p_sequencer(virtual_sequencer)

  write_base_sequence w_seq;
  only_write   only_w_seq;
  no_write     no_w_seq;
  write_dist     w_dist_seq;
  
  read_base_sequence  r_seq;
  only_read  only_r_seq;
  no_read     no_r_seq;
  read_dist     r_dist_seq;


  virtual_sequencer vseqr;

  function new(string name = "virtual_sequence_fifo");
    super.new(name);
    
    w_seq       = write_base_sequence::type_id::create("w_seq");
  	only_w_seq  = only_write::type_id::create("only_w_seq");
  	no_w_seq    = no_write::type_id::create("no_w_seq");
  	w_dist_seq  = write_dist::type_id::create("w_dist_seq");

  	r_seq       = read_base_sequence::type_id::create("r_seq");
  	only_r_seq  = only_read::type_id::create("only_r_seq");
  	no_r_seq    = no_read::type_id::create("no_r_seq");
  	r_dist_seq  = read_dist::type_id::create("r_dist_seq");

  endfunction

	task body();
		`uvm_info(get_type_name(), "Starting FIFO virtual sequence", UVM_LOW)
	/*// ------parallel base sequences------
	fork
			w_seq.start(p_sequencer.wr_seqr);
			r_seq.start(p_sequencer.rd_seqr);
  join*/

    // ------no read, only write------
    fork
      begin
        only_w_seq.start(p_sequencer.wr_seqr);
      end
      begin
        no_r_seq.start(p_sequencer.rd_seqr);
        #100;
      end
    join
      
    // ------no write, only read------
    fork
      begin
        no_w_seq.start(p_sequencer.wr_seqr);
        #100;
      end
      begin
        only_r_seq.start(p_sequencer.rd_seqr);
      end
    join

    // ------randomized distribution------
    fork
      begin
        r_dist_seq.start(p_sequencer.rd_seqr);
      end
      begin
        w_dist_seq.start(p_sequencer.wr_seqr);
        #100;
      end
    join

  endtask
endclass

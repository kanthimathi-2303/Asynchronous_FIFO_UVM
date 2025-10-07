/*`include "uvm_macros.svh"
import uvm_pkg::*;
`include "defines_fifo.sv"
`include "write_sequence_item_fifo.sv"
*/
class write_base_sequence extends uvm_sequence#(write_sequence_item);

  `uvm_object_utils(write_base_sequence)

  function new(string name = "write_base_sequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat (`no_of_trans) begin
      req = write_sequence_item::type_id::create("req");
      wait_for_grant();
      assert(req.randomize()) else
        `uvm_error("FIFO_write_SEQ", "Randomization failed for req");
      send_request(req);
      wait_for_item_done();
    end
  endtask

endclass

class only_write extends uvm_sequence#(write_sequence_item);

  `uvm_object_utils(only_write)

  function new(string name = "only_write");
		super.new(name);
	endfunction

	task body();
		repeat(`no_of_trans) begin
		`uvm_do_with(req,{ req.winc == 1; req.wdata inside {[0:255]};})
		end
	endtask

endclass

class no_write extends uvm_sequence#(write_sequence_item);

  `uvm_object_utils(no_write)

  function new(string name = "no_write");
		super.new(name);
	endfunction

	task body();
		repeat(`no_of_trans) begin
          `uvm_do_with(req,{ req.winc == 0;})
		end
	endtask

endclass

class write_dist extends uvm_sequence#(write_sequence_item);

  `uvm_object_utils(write_dist)

  function new(string name = "write_dist");
		super.new(name);
	endfunction

	task body();
		repeat(`no_of_trans) begin
          `uvm_do_with(req, { req.winc dist { 1 := 80, 0 := 20 }; })
		end
	endtask

endclass

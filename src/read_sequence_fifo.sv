/*`include "uvm_macros.svh"
import uvm_pkg::*;
`include "defines_fifo.sv"
`include "read_sequence_item_fifo.sv"
*/
class read_base_sequence extends uvm_sequence#(read_sequence_item);

  `uvm_object_utils(read_base_sequence)

  function new(string name = "read_base_sequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat (`no_of_trans) begin
      req = read_sequence_item::type_id::create("req");
      wait_for_grant();
      assert(req.randomize()) else
        `uvm_error("FIFO_read_SEQ", "Randomization failed for req");
      send_request(req);
      wait_for_item_done();
    end
  endtask

endclass

class no_read extends uvm_sequence#(read_sequence_item);

  `uvm_object_utils(no_read)

  function new(string name = "no_read");
                super.new(name);
        endfunction

        task body();
                repeat(`no_of_trans) begin
                  `uvm_do_with(req,{ req.rinc == 0; })
                end
        endtask

endclass

class only_read extends uvm_sequence#(read_sequence_item);

  `uvm_object_utils(only_read)

  function new(string name = "only_read");
                super.new(name);
        endfunction

        task body();
                repeat(`no_of_trans) begin
                  `uvm_do_with(req,{ req.rinc == 1; })
                end
        endtask

endclass

class read_dist extends uvm_sequence#(read_sequence_item);

  `uvm_object_utils(read_dist)

  function new(string name = "only_read");
                super.new(name);
        endfunction

        task body();
                repeat(`no_of_trans) begin
                  `uvm_do_with(req, { req.rinc dist { 1 := 80, 0 := 20 }; })
                end
        endtask

endclass


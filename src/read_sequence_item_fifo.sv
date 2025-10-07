/*`include "defines_fifo.sv"
`include "uvm_macros.svh"
import uvm_pkg::*;
*/
class read_sequence_item extends uvm_sequence_item;
        //inputs
        rand logic rinc;

        //outputs
        logic [`DATA_WIDTH-1:0] rdata;
        logic rempty;

        `uvm_object_utils_begin(read_sequence_item)
                        `uvm_field_int(rinc,UVM_ALL_ON)
                        `uvm_field_int(rdata,UVM_ALL_ON)
                        `uvm_field_int(rempty,UVM_ALL_ON)
        `uvm_object_utils_end

        function new(string name = "read_sequence_item");
                super.new(name);
        endfunction

endclass

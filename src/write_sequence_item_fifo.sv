/*`include "defines_fifo.sv"
`include "uvm_macros.svh"
import uvm_pkg::*;
*/
class write_sequence_item extends uvm_sequence_item;
        //inputs
        rand logic [`DATA_WIDTH-1:0] wdata;
        rand logic winc;

        //outputs
        logic wfull;

        `uvm_object_utils_begin(write_sequence_item)
                        `uvm_field_int(wdata,UVM_ALL_ON)
                        `uvm_field_int(winc,UVM_ALL_ON)
                        `uvm_field_int(wfull,UVM_ALL_ON)
        `uvm_object_utils_end

        function new(string name = "write_sequence_item");
                super.new(name);
        endfunction

endclass

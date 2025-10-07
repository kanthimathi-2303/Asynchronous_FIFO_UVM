/*`include "uvm_macros.svh"
import uvm_pkg::*;
`include "defines_fifo.sv"
`include "read_sequence_item_fifo.sv"
`include "write_sequence_item_fifo.sv"
*/
class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  virtual if_fifo vif;

  write_sequence_item wr_trans;
  read_sequence_item  rd_trans;

  int wr_pass_count, wr_fail_count;
  int rd_pass_count, rd_fail_count;

  bit [`DATA_WIDTH-1:0] expected_q[$], actual_q[$];

  uvm_tlm_analysis_fifo #(write_sequence_item) wr_sb_fifo;
  uvm_tlm_analysis_fifo #(read_sequence_item)  rd_sb_fifo;

  function new(string name="scoreboard", uvm_component parent=null);
    super.new(name, parent);
    wr_sb_fifo = new("wr_sb_fifo", this);
    rd_sb_fifo = new("rd_sb_fifo", this);
    wr_pass_count = 0;
    wr_fail_count = 0;
    rd_pass_count = 0;
    rd_fail_count = 0;
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual if_fifo)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NOVIF", "No virtual interface found for FIFO scoreboard");
    end
  endfunction

  task run_phase(uvm_phase phase);
    fork

      forever begin
        @(negedge vif.wrst_n or negedge vif.rrst_n);
        expected_q.delete();
        actual_q.delete();
        wr_pass_count = 0;
        wr_fail_count = 0;
        rd_pass_count = 0;
        rd_fail_count = 0;
        `uvm_info(get_type_name(), "SCOREBOARD RESET DETECTED", UVM_LOW);
      end


      forever begin //write
        wr_sb_fifo.get(wr_trans);
        
        if (wr_trans.winc && wr_trans.wfull) begin
          wr_fail_count++;
          `uvm_error(get_type_name(),
            $sformatf("[%0t] WRITE attempted when FULL! data=0x%0h",
                      $time, wr_trans.wdata));
          $display("----------------------------- WRITE FAIL -----------------------------");
        end 
        else if (wr_trans.winc && !wr_trans.wfull) begin
          expected_q.push_back(wr_trans.wdata);
          wr_pass_count++;
          `uvm_info(get_type_name(),
            $sformatf("[%0t] WRITE accepted: data=0x%0h",
                      $time, wr_trans.wdata), UVM_LOW);
          $display("----------------------------- WRITE PASS -----------------------------");
        end
      end

      forever begin //read
        rd_sb_fifo.get(rd_trans);

        if (rd_trans.rinc && rd_trans.rempty) begin
          rd_fail_count++;
          `uvm_error(get_type_name(),
            $sformatf("[%0t] READ attempted when EMPTY!", $time));
          $display("----------------------------- READ FAIL -----------------------------");
        end
        else if (rd_trans.rinc && !rd_trans.rempty) begin
          if (expected_q.size() == 0) begin
            rd_fail_count++;
            `uvm_error(get_type_name(),
              $sformatf("[%0t] READ data=0x%0h but expected queue empty",
                        $time, rd_trans.rdata));
            $display("----------------------------- READ FAIL -----------------------------");
          end
          else begin
            bit [`DATA_WIDTH-1:0] exp_data = expected_q.pop_front();
            if (rd_trans.rdata === exp_data) begin
              rd_pass_count++;
              `uvm_info(get_type_name(),
                $sformatf("[%0t] READ match: data=0x%0h", $time, rd_trans.rdata),
                UVM_LOW);
              $display("----------------------------- READ PASS -----------------------------");
            end
            else begin
              rd_fail_count++;
              `uvm_error(get_type_name(),
                $sformatf("[%0t] DATA MISMATCH exp=0x%0h got=0x%0h",
                          $time, exp_data, rd_trans.rdata));
              $display("----------------------------- READ FAIL -----------------------------");
            end
          end
        end
      end
    join_none
  endtask

  function void report_phase(uvm_phase phase);
    int total_pass = wr_pass_count + rd_pass_count;
    int total_fail = wr_fail_count + rd_fail_count;

    `uvm_info(get_type_name(),
              $sformatf("\n--- SCOREBOARD SUMMARY ---\n\
      WRITE : Passed=%0d  Failed=%0d\n\
      READ  : Passed=%0d  Failed=%0d\n\
      TOTAL : Passed=%0d  Failed=%0d  Remaining_in_FIFO=%0d\n",
      wr_pass_count, wr_fail_count,
      rd_pass_count, rd_fail_count,
      total_pass, total_fail,
      expected_q.size()), UVM_NONE);
  endfunction

endclass


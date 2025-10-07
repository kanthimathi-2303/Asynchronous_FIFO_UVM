`include "defines_fifo.sv"
`include "fifo_design.v"
`include "if_fifo.sv"
`include "fifo_package.sv"

import uvm_pkg::*;
import fifo_pkg::*;

module top;
  	bit wclk,rclk;
  	bit wrst_n,rrst_n;
  	
  	initial wclk = 1'b0;
  	always #5 wclk = ~ wclk;

		initial rclk = 1'b0;
		always #10 rclk = ~ rclk;
  
  	initial begin
			wrst_n = 1'b0;
			rrst_n = 1'b0;
			#10;
			wrst_n = 1'b1;
			rrst_n = 1'b1;
			#1;
			wrst_n = 1'b0;
			rrst_n = 1'b0;
			#1;
			wrst_n = 1'b1;
			rrst_n = 1'b1;

    end

  if_fifo intf(wclk,wrst_n,rclk,rrst_n);

	FIFO dut(
		.wclk(intf.wclk),
		.rclk(intf.rclk),
		.wrst_n(intf.wrst_n),
		.rrst_n(intf.rrst_n),
		.winc(intf.winc),
		.rinc(intf.rinc),
		.wdata(intf.wdata),
		.rdata(intf.rdata),
		.wfull(intf.wfull),
		.rempty(intf.rempty)
	);

  initial begin
    uvm_config_db#(virtual if_fifo)::set(null,"*","vif",intf); 
  end
  
  initial begin
    run_test("base_test");
  #100; $finish;
  end
endmodule

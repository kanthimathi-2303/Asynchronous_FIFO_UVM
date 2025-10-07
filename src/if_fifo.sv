`include "defines_fifo.sv"

interface if_fifo(input bit wclk, wrst_n, input bit rclk, rrst_n);
  //write
	logic [`DATA_WIDTH - 1:0] wdata;
	logic winc;
	logic wfull;
  
	//read
	logic [`DATA_WIDTH - 1:0] rdata;
	logic rinc;
	logic rempty;

	clocking wdrv_cb @(posedge wclk);
		default input #1 output #1;
		input wclk, wrst_n;
		output wdata;
		output winc;
	endclocking

	clocking wmon_cb @(posedge wclk);
		default input #1 output #1;
		input wclk, wrst_n;
		input wdata;
		input winc;
		input wfull;
	endclocking

	clocking wsb_cb @(posedge wclk);
		input wclk, wrst_n;
	endclocking

	clocking rdrv_cb @(posedge rclk);
		default input #1 output #1;
		input rclk, rrst_n;
		output rinc;
	endclocking

	clocking rmon_cb @(posedge rclk);
		default input #1 output #1;
		input rclk, rrst_n;
		input rdata;
		input rempty;
	endclocking

	clocking rsb_cb @(posedge rclk);
		input rclk, rrst_n;
	endclocking

	// Write side
	modport wDRV(clocking wdrv_cb);
	modport wMON(clocking wmon_cb);
	modport wSB(clocking wsb_cb);

	// Read side
	modport rDRV(clocking rdrv_cb);
	modport rMON(clocking rmon_cb);
	modport rSB(clocking rsb_cb);

endinterface


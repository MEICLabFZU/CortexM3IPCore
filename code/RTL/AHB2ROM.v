
////////////////////////////////////////////////////////////////////////////////
// AHB-Lite Memory Module
////////////////////////////////////////////////////////////////////////////////
module AHB2ROM
   (
   input wire           HSEL,
   input wire           HCLK,
   input wire           HRESETn,
   input wire           HREADY,
   input wire    [31:0] HADDR,
   input wire     [1:0] HTRANS,
   input wire           HWRITE,
   input wire     [2:0] HSIZE,
   input wire    [31:0] HWDATA,
   output wire          HREADYOUT,
   output wire   [31:0] HRDATA
   );

   assign HREADYOUT = 1'b1; // Always ready

wire [31:0] hrdata;


   // Memory Array
   rom  rom (
	.address(HADDR[14:2]),
	.clock(HCLK),
	.q(HRDATA)
	);

endmodule

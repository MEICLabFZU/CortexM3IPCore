
`timescale 1ns/1ns

module DE10ARM(
   input  wire          CLK,                  // Oscillator
   input  wire          RESET,                // Reset
   input  wire          RESETn,
   // Debug
   input  wire          TDI,                  // JTAG TDI
   input  wire          TCK,                  // SWD Clk / JTAG TCK
   inout  wire          TMS,                  // SWD I/O / JTAG TMS
   output wire          TDO,                   // SWV     / JTAG TDO
	
   //test
   output wire		TRESET,
   output wire		Treg_sys_rst_n,

   //peripherals ports

  inout  wire  [7:0]    b_pad_gpio_porta,

  input  wire           uart0_rxd,
  output wire           uart0_txd,
  output wire           uart0_txen,

  input  wire           uart1_rxd,
  output wire           uart1_txd,
  output wire           uart1_txen,

  input  wire           uart2_rxd,
  output wire           uart2_txd,
  output wire           uart2_txen,

  input  wire           timer1_extin
);
  reg    reg_sys_rst_n;
//test
assign TRESET= RESET;
assign Treg_sys_rst_n = reg_sys_rst_n;



   wire  reset_n = RESET;
   wire  fclk;
   wire  [239:0] irq = {240'b0000_0000_0000_0000};

   // Clock divider, divide the frequency by 4, hence less time constraint
   reg      clk_div;

   always @(posedge CLK or negedge RESETn)
   begin
	if(!RESETn)
	clk_div <= 0;
	else 
	begin        
        clk_div <= ~clk_div;
      end
end
   
  assign fclk = clk_div;

  // System level reset
   wire   lockup;             // Lockup signal from CPU
   wire   sys_reset_req;      // System reset request from CPU or debug host
 
   always @(posedge fclk or negedge reset_n)
   begin
      if (!reset_n)
         reg_sys_rst_n <= 1'b0;
      else
         if ( sys_reset_req | lockup )
            reg_sys_rst_n <= 1'b0;
         else
            reg_sys_rst_n <= 1'b1;
   end

   //Internal wires
    //
    //
   /////////////////////////////////////////////////////////////////////////////
   // Connect Code Bus to ROM
   /////////////////////////////////////////////////////////////////////////////

   // CPU I-Code bus
   wire   [31:0] haddri;
   wire    [1:0] htransi;
   wire    [2:0] hsizei;
   wire    [2:0] hbursti;
   wire    [3:0] hproti;
   wire    [1:0] memattri;
   wire   [31:0] hrdatai;
   wire          hreadyi;


   // CPU D-Code bus
   wire   [31:0] haddrd;
   wire    [1:0] htransd;
   wire    [1:0] hmasterd;
   wire    [2:0] hsized;
   wire    [2:0] hburstd;
   wire    [3:0] hprotd;
   wire    [1:0] memattrd;
   wire   [31:0] hwdatad;
   wire          hwrited;
   wire          exreqd;
   wire   [31:0] hrdatad;
   wire          hreadyd;
 
   wire          exrespd = 1'b0;

  
   /////////////////////////////////////////////////////////////////////////////
   // Connect System Bus to RAM and Peripherals
   /////////////////////////////////////////////////////////////////////////////

   // CPU System bus
   wire   [31:0] haddrs; 
   wire    [2:0] hbursts; 
   wire          hmastlocks; 
   wire    [3:0] hprots; 
   wire    [2:0] hsizes; 
   wire    [1:0] htranss; 
   wire   [31:0] hwdatas; 
   wire          hwrites; 
   wire   [31:0] hrdatas; 
   wire          hreadys; 

   wire          exresps = 1'b0;


   /////////////////////////////////////////////////////////////////////////////
   // Debug Signals
   /////////////////////////////////////////////////////////////////////////////

   // Debug signals (TDO pin is used for SWV unless JTAG mode is active)
   wire          dbg_tdo;                    // SWV / JTAG TDO
   wire          dbg_tdo_nen;                // SWV / JTAG TDO tristate enable (active low)
   wire          dbg_swdo;                   // SWD I/O 3-state output
   wire          dbg_swdo_en;                // SWD I/O 3-state enable
   wire          dbg_jtag_nsw;               // SWD in JTAG state (HIGH)
   wire          dbg_swo;                    // Serial wire viewer/output
   wire          tdo_enable     = !dbg_tdo_nen | !dbg_jtag_nsw;
   wire          tdo_tms        = dbg_jtag_nsw         ? dbg_tdo    : dbg_swo;
   assign        TMS            = dbg_swdo_en          ? dbg_swdo   : 1'bz;
   assign        TDO            = tdo_enable           ? tdo_tms    : 1'bz;

   // CoreSight requires a loopback from REQ to ACK for a minimal
   // debug power control implementation
   wire          cpu0cdbgpwrupreq;          // Debug Power Domain up request
   wire          cpu0cdbgpwrupack;          // Debug Power Domain up acknowledge
   assign        cpu0cdbgpwrupack = cpu0cdbgpwrupreq;

     //BusMatrix
  
    // output port mi0
    wire         hselmi0;          // slave select
    wire  [31:0] haddrmi0;         // address bus
    wire   [1:0] htransmi0;        // transfer type
    wire         hwritemi0;        // transfer direction
    wire   [2:0] hsizemi0;         // transfer size
    wire   [2:0] hburstmi0;        // burst type
    wire   [3:0] hprotmi0;         // protection control
    wire   [3:0] hmastermi0;       // master select
    wire  [31:0] hwdatami0;        // write data
    wire         hmastlockmi0;     // locked sequence
    wire         hreadymuxmi0;     // transfer done

    wire  [31:0] hrdatami0;        // read data bus
    wire         hreadyoutmi0;     // hready feedback
    wire   [1:0] hrespmi0;         // transfer response
    wire  [31:0] hausermi0;        // address user signals
    wire  [31:0] hwusermi0;        // write-data usER signals
    wire  [31:0] hrusermi0;        // read-data useR signals

    // output port mi1
    wire         hselmi1;          // slave select
    wire  [31:0] haddrmi1;         // address bus
    wire   [1:0] htransmi1;        // transfer type
    wire         hwritemi1;        // transfer direction
    wire   [2:0] hsizemi1;         // transfer size
    wire   [2:0] hburstmi1;        // burst type
    wire   [3:0] hprotmi1;         // protection control
    wire   [3:0] hmastermi1;       // master select
    wire  [31:0] hwdatami1;        // write data
    wire         hmastlockmi1;     // locked sequence
    wire         hreadymuxmi1;     // transfer done

    wire  [31:0] hrdatami1;        // read data bus
    wire         hreadyoutmi1;     // hready feedback
    wire   [1:0] hrespmi1;         // transfer response
    wire  [31:0] hausermi1;        // address user signals
    wire  [31:0] hwusermi1;        // write-data usER signals
    wire  [31:0] hrusermi1;        // read-data useR signals

    // output port mi2
    wire         hselmi2;          // slave select
    wire  [31:0] haddrmi2;         // address bus
    wire   [1:0] htransmi2;        // transfer type
    wire         hwritemi2;        // transfer direction
    wire   [2:0] hsizemi2;         // transfer size
    wire   [2:0] hburstmi2;        // burst type
    wire   [3:0] hprotmi2;         // protection control
    wire   [3:0] hmastermi2;       // master select
    wire  [31:0] hwdatami2;        // write data
    wire         hmastlockmi2;     // locked sequence
    wire         hreadymuxmi2;     // transfer done

    wire  [31:0] hrdatami2;        // read data bus
    wire         hreadyoutmi2;     // hready feedback
    wire   [1:0] hrespmi2;         // transfer response
    wire  [31:0] hausermi2;        // address user signals
    wire  [31:0] hwusermi2;        // write-data usER signal
    wire  [31:0] hrusermi2;        // read-data useR signals


   /////////////////////////////////////////////////////////////////////////////
   // Cortex-M0 Core
   /////////////////////////////////////////////////////////////////////////////

   // DesignStart simplified integration level
   CORTEXM3INTEGRATIONDS u_CORTEXM3INTEGRATION (
      // Inputs
      .ISOLATEn       (1'b1),               // Active low to isolate core power domain
      .RETAINn        (1'b1),               // Active low to retain core state during power-down

      // Resets
      .PORESETn       (reset_n),            // Power on reset - reset processor and debugSynchronous to FCLK and HCLK
      .SYSRESETn      (reg_sys_rst_n),      // System reset   - reset processor onlySynchronous to FCLK and HCLK
      .RSTBYPASS      (1'b0),               // Reset bypass - active high to disable internal generated reset for testing (e.gATPG)
      .CGBYPASS       (1'b0),               // Clock gating bypass - active high to disable internal clock gating for testing
      .SE             (1'b0),               // DFT is tied off in this example

      // Clocks
      .FCLK           (fclk),               // Free running clock - NVIC, SysTick, debug
      .HCLK           (fclk),               // System clock - AHB, processor
                                            // it is separated so that it can be gated off when no debugger is attached
      .TRACECLKIN     (fclk),               // Trace clock input.  REVISIT, does it want its own named signal as an input?
      // SysTick
      .STCLK          (fclk),               // External reference clock for SysTick (Not really a clock, it is sampled by DFF)
                                            // Must be synchronous to FCLK or tied when no alternative clock source
      .STCALIB        ({1'b1,               // No alternative clock source
                        1'b0,               // Exact multiple of 10ms from FCLK
                        24'h003D08F}),      // Calibration value for SysTick for 25 MHz source

      .AUXFAULT       ({32{1'b0}}),         // Auxiliary Fault Status Register inputs: Connect to fault status generating logic
                                            // if required. Result appears in the Auxiliary Fault Status Register at address
                                            // 0xE000ED3C. A one-cycle pulse of information results in the information being stored
                                            // in the corresponding bit until a write-clear occurs.

      // Configuration - system
      .BIGEND         (1'b0),               // Select when exiting system reset - Peripherals in this system do not support BIGEND
      .DNOTITRANS     (1'b1),               // I-CODE & D-CODE merging configuration.
                                            // This disable I-CODE from generating a transfer when D-CODE bus need a transfer
                                            // Must be HIGH when using the Designstart system

      // SWJDAP signal for single processor mode
      .nTRST          (1'b1),               // JTAG TAP Reset
      .SWCLKTCK       (TCK),                // SW/JTAG Clock
      .SWDITMS        (TMS),                // SW Debug Data In / JTAG Test Mode Select
      .TDI            (TDI),                // JTAG TAP Data In / Alternative input function
      .CDBGPWRUPACK   (cpu0cdbgpwrupack),   // Debug Power Domain up acknowledge.

      // IRQs
      .INTISR         (irq[239:0]),         // Interrupts
      .INTNMI         (1'b0),               // Non-maskable Interrupt

      // I-CODE Bus
      .HREADYI        (hreadyi),            // I-CODE bus ready
      .HRDATAI        (hrdatai),            // I-CODE bus read data
      .HRESPI         (2'b00),             // I-CODE bus response
      .IFLUSH         (1'b0),               // Prefetch flush - fixed when using the Designstart system

      // D-CODE Bus
      .HREADYD        (hreadyd),            // D-CODE bus ready
      .HRDATAD        (hrdatad),            // D-CODE bus read data
      .HRESPD         (2'b00),             // D-CODE bus response
      .EXRESPD        (exrespd),            // D-CODE bus exclusive response

      // System Bus
      .HREADYS        (hreadys),            // System bus ready
      .HRDATAS        (hrdatas),            // System bus read data
      .HRESPS         (2'b00),             // System bus response
      .EXRESPS        (exresps),            // System bus exclusive response

      // Sleep
      .RXEV           (1'b0),               // Receive Event input
      .SLEEPHOLDREQn  (1'b1),               // Extend Sleep request

      // External Debug Request
      .EDBGRQ         (1'b0),               // External Debug request to CPU
      .DBGRESTART     (1'b0),               // Debug Restart request - Not needed in a single CPU system

      // DAP HMASTER override
      .FIXMASTERTYPE  (1'b0),               // Tie High to override HMASTER for AHB-AP accesses

      // WIC
      .WICENREQ       (1'b0),               // Active HIGH request for deep sleep to be WIC-based deep sleep
                                            // This should be driven from a PMU

      // Timestamp interface
      .TSVALUEB       ({48{1'b0}}),         // Binary coded timestamp value for trace - Trace is not used in this course
      // Timestamp clock ratio change is rarely used

      // Configuration - debug
      .DBGEN          (1'b1),               // Halting Debug Enable
      .NIDEN          (1'b1),               // Non-invasive debug enable for ETM
      .MPUDISABLE     (1'b0),               // Tie high to emulate processor with no MPU

      // SWJDAP signal for single processor mode
      .TDO            (dbg_tdo),            // JTAG TAP Data Out // REVISIT needs mux for SWV
      .nTDOEN         (dbg_tdo_nen),        // TDO enable
      .CDBGPWRUPREQ   (cpu0cdbgpwrupreq),   // Debug Power Domain up request
      .SWDO           (dbg_swdo),           // SW Data Out
      .SWDOEN         (dbg_swdo_en),        // SW Data Out Enable
      .JTAGNSW        (dbg_jtag_nsw),       // JTAG/not Serial Wire Mode

      // Single Wire Viewer
      .SWV            (dbg_swo),            // SingleWire Viewer Data

      // TPIU signals for single processor mode
      .TRACECLK       (),                   // TRACECLK output
      .TRACEDATA      (),                   // Trace Data

      // CoreSight AHB Trace Macrocell (HTM) bus capture interface
      // Connected here for visibility but usually not used in SoC.
      .HTMDHADDR      (),                   // HTM data HADDR
      .HTMDHTRANS     (),                   // HTM data HTRANS
      .HTMDHSIZE      (),                   // HTM data HSIZE
      .HTMDHBURST     (),                   // HTM data HBURST
      .HTMDHPROT      (),                   // HTM data HPROT
      .HTMDHWDATA     (),                   // HTM data HWDATA
      .HTMDHWRITE     (),                   // HTM data HWRITE
      .HTMDHRDATA     (),                   // HTM data HRDATA
      .HTMDHREADY     (),                   // HTM data HREADY
      .HTMDHRESP      (),                   // HTM data HRESP

      // AHB I-Code bus
      .HADDRI         (haddri),             // I-CODE bus address
      .HTRANSI        (htransi),            // I-CODE bus transfer type
      .HSIZEI         (hsizei),             // I-CODE bus transfer size
      .HBURSTI        (hbursti),            // I-CODE bus burst length
      .HPROTI         (hproti),             // i-code bus protection
      .MEMATTRI       (memattri),           // I-CODE bus memory attributes

      // AHB D-Code bus
      .HADDRD         (haddrd),             // D-CODE bus address
      .HTRANSD        (htransd),            // D-CODE bus transfer type
      .HSIZED         (hsized),             // D-CODE bus transfer size
      .HWRITED        (hwrited),            // D-CODE bus write not read
      .HBURSTD        (hburstd),            // D-CODE bus burst length
      .HPROTD         (hprotd),             // D-CODE bus protection
      .MEMATTRD       (memattrd),           // D-CODE bus memory attributes
      .HMASTERD       (hmasterd),           // D-CODE bus master
      .HWDATAD        (hwdatad),            // D-CODE bus write data
      .EXREQD         (exreqd),             // D-CODE bus exclusive request

      // AHB System bus
      .HADDRS         (haddrs),             // System bus address
      .HTRANSS        (htranss),            // System bus transfer type
      .HSIZES         (hsizes),             // System bus transfer size
      .HWRITES        (hwrites),            // System bus write not read
      .HBURSTS        (hbursts),            // System bus burst length
      .HPROTS         (hprots),             // System bus protection
      .HMASTLOCKS     (hmastlocks),         // System bus lock
      .MEMATTRS       (),                   // System bus memory attributes
      .HMASTERS       (),                   // System bus master
      .HWDATAS        (hwdatas),            // System bus write data
      .EXREQS         (),                   // System bus exclusive request

      // Status
      .BRCHSTAT       (),                   // Branch State
      .HALTED         (),                   // The processor is halted
      .DBGRESTARTED   (),                   // Debug Restart interface handshaking
      .LOCKUP         (lockup),             // The processor is locked up
      .SLEEPING       (),                   // The processor is in sleep mdoe (sleep/deep sleep)
      .SLEEPDEEP      (),                   // The processor is in deep sleep mode
      .SLEEPHOLDACKn  (),                   // Acknowledge for SLEEPHOLDREQn
      .ETMINTNUM      (),                   // Current exception number
      .ETMINTSTAT     (),                   // Exception/Interrupt activation status
      .CURRPRI        (),                   // Current exception priority
      .TRCENA         (),                   // Trace Enable

      // Reset Request
      .SYSRESETREQ    (sys_reset_req),      // System Reset Request

      // Events
      .TXEV           (),                   // Transmit Event

      // Clock gating control
      .GATEHCLK       (),                   // when high, HCLK can be turned off

      .WAKEUP         (),                   // Active HIGH signal from WIC to the PMU that indicates a wake-up event has
                                            // occurred and the system requires clocks and power
      .WICENACK       ()                    // Acknowledge for WICENREQ - WIC operation deep sleep mode
   );


   //BusMatrix instantiation

   BusMatrix3x3 u_BusMatrix3x3 (

    // Common AHB signals
    .HCLK		(fclk),
    .HRESETn		(reg_sys_rst_n),

    // System address remapping control
    .REMAP		({4{1'b0}}),

    // Input port SI0 (inputs from master 0)
    .HSELSI0		(htranss[1]),
    .HADDRSI0		(haddrs),
    .HTRANSSI0		(htranss),
    .HWRITESI0		(hwrites),
    .HSIZESI0		(hsizes),
    .HBURSTSI0		(hbursts),
    .HPROTSI0		(hprots),
    .HMASTERSI0		(4'b0000),
    .HWDATASI0		(hwdatas),
    .HMASTLOCKSI0	(1'b0),
    .HREADYSI0		(hreadys),
    .HAUSERSI0		({32{1'b0}}),
    .HWUSERSI0		({32{1'b0}}),

    
    // Input port SI1 (inputs from master 1)
    .HSELSI1		(htransd[1]),
    .HADDRSI1		(haddrd),
    .HTRANSSI1		(htransd),
    .HWRITESI1		(hwrited),
    .HSIZESI1		(hsized),
    .HBURSTSI1		(hburstd),
    .HPROTSI1		(hprotd),
    .HMASTERSI1		(4'b0001),
    .HWDATASI1		(hwdatad),
    .HMASTLOCKSI1	(1'b0),
    .HREADYSI1		(hreadyd),
    .HAUSERSI1		({32{1'b0}}),
    .HWUSERSI1		({32{1'b0}}),

    // Input port SI2 (inputs from master 2)
    .HSELSI2(htransi[1]),
    .HADDRSI2(haddri),
    .HTRANSSI2(htransi),
    .HWRITESI2(1'b0),
    .HSIZESI2(hsizei),
    .HBURSTSI2(hbursti),
    .HPROTSI2(hproti),
    .HMASTERSI2(4'b0010),
    .HWDATASI2({32{1'b0}}),
    .HMASTLOCKSI2(1'b0),
    .HREADYSI2(hreadyi),
    .HAUSERSI2({32{1'b0}}),
    .HWUSERSI2({32{1'b0}}),


    // Output port MI0 (inputs from slave 0)
    .HRDATAMI0		(hrdatami0),
    .HREADYOUTMI0	(hreadyoutmi0),
    .HRESPMI0		(2'b00),
    .HRUSERMI0		(32'b0),

    // Output port MI1 (inputs from slave 1)
    .HRDATAMI1		(hrdatami1),
    .HREADYOUTMI1	(hreadyoutmi1),
    .HRESPMI1		(2'b00),
    .HRUSERMI1		(32'b0),

    // Output port MI2 (inputs from slave 2)
    .HRDATAMI2		(hrdatami2),
    .HREADYOUTMI2	(hreadyoutmi2),
    .HRESPMI2		(2'b00),
    .HRUSERMI2		(32'b0),

    // Scan test dummy signals; not connected until scan insertion
    .SCANENABLE		(1'b0),   // Scan Test Mode Enable
    .SCANINHCLK		(1'b0),   // Scan Chain Input


    // Output port MI0 (outputs to slave 0)
    .HSELMI0		(hselmi0),
    .HADDRMI0		(haddrmi0),
    .HTRANSMI0		(htransmi0),
    .HWRITEMI0		(hwritemi0),
    .HSIZEMI0		(hsizemi0),
    .HBURSTMI0		(hburstmi0),
    .HPROTMI0		(hprotmi0),
    .HMASTERMI0		(hmastermi0),
    .HWDATAMI0		(hwdatami0),
    .HMASTLOCKMI0	(hmastlockmi0),
    .HREADYMUXMI0	(hreadymuxmi0),
    .HAUSERMI0		(hausermi0),
    .HWUSERMI0		(hwusermi0),

    // Output port MI1 (outputs to slave 1)
    .HSELMI1		(hselmi1),
    .HADDRMI1		(haddrmi1),
    .HTRANSMI1		(htransmi1),
    .HWRITEMI1		(hwritemi1),
    .HSIZEMI1		(hsizemi1),
    .HBURSTMI1		(hburstmi1),
    .HPROTMI1		(hprotmi1),
    .HMASTERMI1		(hmastermi1),
    .HWDATAMI1		(hwdatami1),
    .HMASTLOCKMI1	(hmastlockmi1),
    .HREADYMUXMI1	(hreadymuxmi1),
    .HAUSERMI1		(hausermi1),
    .HWUSERMI1		(hwusermi1),

    // Output port MI2 (outputs to slave 2)
    .HSELMI2		(hselmi2),
    .HADDRMI2		(haddrmi2),
    .HTRANSMI2		(htransmi2),
    .HWRITEMI2		(hwritemi2),
    .HSIZEMI2		(hsizemi2),
    .HBURSTMI2		(hburstmi2),
    .HPROTMI2		(hprotmi2),
    .HMASTERMI2		(hmastermi2),
    .HWDATAMI2		(hwdatami2),
    .HMASTLOCKMI2	(hmastlockmi2),
    .HREADYMUXMI2	(hreadymuxmi2),
    .HAUSERMI2		(hausermi2),
    .HWUSERMI2		(hwusermi2),

    // Input port SI0 (outputs to master 0)
    .HRDATASI0		(hrdatas),
    .HREADYOUTSI0	(hreadys),
    .HRESPSI0		(),
    .HRUSERSI0		(),

    // Input port SI1 (outputs to master 1)
    .HRDATASI1		(hrdatad),
    .HREADYOUTSI1	(hreadyd),
    .HRESPSI1		(),
    .HRUSERSI1		(),

     // Input port SI2 (outputs to master 2)
    .HRDATASI2(hrdatai),
    .HREADYOUTSI2(hreadyi),
    .HRESPSI2(),
    .HRUSERSI2(),

    // Scan test dummy signals; not connected until scan insertion
    .SCANOUTHCLK	(scanouthclk)   // Scan Chain Output
);

		  
   AHB2MEM u_rom(

	.HSEL(hselmi0),
	.HCLK(fclk),
	.HRESETn(reg_sys_rst_n),
	.HREADY(hreadymuxmi0),
	.HADDR(haddrmi0),
	.HTRANS(htransmi0),
	.HWRITE(hwritemi0),
	.HSIZE(hsizemi0),
	.HWDATA(hwdatami0),
	.HREADYOUT(hreadyoutmi0),
	.HRDATA(hrdatami0)
);



   AHB2MEM u_sram(

	.HSEL(hselmi2),
	.HCLK(fclk),
	.HRESETn(reg_sys_rst_n),
	.HREADY(hreadymuxmi2),
	.HADDR(haddrmi2),
	.HTRANS(htransmi2),
	.HWRITE(hwritemi2),
	.HSIZE(hsizemi2),
	.HWDATA(hwdatami2),
	.HREADYOUT(hreadyoutmi2),
	.HRDATA(hrdatami2)
);

    //apb_subsystem instantiation
    cmsdk_apb_subsystem    u_apb_subsystem(
	.HCLK			(fclk),
	.HRESETn		(reg_sys_rst_n),
                           
	.HSEL			(hselmi1),
	.HADDR			(haddrmi1[15:0]),
	.HTRANS			(htransmi1),
	.HWRITE			(hwritemi1),
	.HSIZE			(hsizemi1),
	.HPROT			(hprotmi1),
	.HREADY			(hreadymuxmi1),
	.HWDATA			(hwdatami1),
                                 
	.HREADYOUT		(hreadyoutmi1),
	.HRDATA			(hrdatami1),
	.HRESP			(hrespmi1),
                                                
	.PCLK			(fclk),    
	.PCLKG			(fclk),  
	.PCLKEN			(1'b1),  
	.PRESETn		(reg_sys_rst_n), 
                                     
	.ext12_psel		(),
	.ext13_psel		(),
	.ext14_psel		(),
	.ext15_psel		(),
                                     
	.ext12_prdata		(32'b0),
	.ext12_pready		(1'b0),
	.ext12_pslverr		(1'b0),
                                    
	.ext13_prdata		(32'b0),
	.ext13_pready		(1'b0),
	.ext13_pslverr		(1'b0),

	.ext14_prdata		(32'b0),
	.ext14_pready		(1'b0),
	.ext14_pslverr		(1'b0),

	.ext15_prdata		(32'b0),
	.ext15_pready		(1'b0),
	.ext15_pslverr		(1'b0),
                                       
	.b_pad_gpio_porta	(b_pad_gpio_porta[7:0]),

	.uart0_rxd		(uart0_rxd),
	.uart0_txd		(uart0_txd),
	.uart0_txen		(uart0_txen),
	                                       
	.uart1_rxd		(uart1_rxd),
	.uart1_txd		(uart1_txd),
	.uart1_txen		(uart1_txen),
                                                
	.uart2_rxd		(uart2_rxd),
	.uart2_txd		(uart2_txd),
	.uart2_txen		(uart2_txen),
               
	.timer1_extin		(timer1_extin));


endmodule












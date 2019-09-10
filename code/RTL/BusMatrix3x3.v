//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2001-2013-2018 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
//      SVN Information
//
//      Checked In          : $Date: 2012-10-15 18:01:36 +0100 (Mon, 15 Oct 2012) $
//
//      Revision            : $Revision: 225465 $
//
//      Release Information : Cortex-M System Design Kit-r1p0-01rel0
//
//-----------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
//  Abstract            : BusMatrix is the top-level which connects together
//                        the required Input Stages, MatrixDecodes, Output
//                        Stages and Output Arbitration blocks.
//
//                        Supports the following configured options:
//
//                         - Architecture type 'ahb2',
//                         - 3 slave ports (connecting to masters),
//                         - 3 master ports (connecting to slaves),
//                         - Routing address width of 32 bits,
//                         - Routing data width of 32 bits,
//                         - xUSER signal width of 32 bits,
//                         - Arbiter type 'round',
//                         - Connectivity mapping:
//                             S<0..2> -> M<0..2>,
//                         - Connectivity type 'full'.
//
//------------------------------------------------------------------------------

`timescale 1ns/1ps

module BusMatrix3x3 (

    // Common AHB signals
    HCLK,
    HRESETn,

    // System address remapping control
    REMAP,

    // Input port SI0 (inputs from master 0)
    HSELSI0,
    HADDRSI0,
    HTRANSSI0,
    HWRITESI0,
    HSIZESI0,
    HBURSTSI0,
    HPROTSI0,
    HMASTERSI0,
    HWDATASI0,
    HMASTLOCKSI0,
    HREADYSI0,
    HAUSERSI0,
    HWUSERSI0,

    // Input port SI1 (inputs from master 1)
    HSELSI1,
    HADDRSI1,
    HTRANSSI1,
    HWRITESI1,
    HSIZESI1,
    HBURSTSI1,
    HPROTSI1,
    HMASTERSI1,
    HWDATASI1,
    HMASTLOCKSI1,
    HREADYSI1,
    HAUSERSI1,
    HWUSERSI1,

    // Input port SI2 (inputs from master 2)
    HSELSI2,
    HADDRSI2,
    HTRANSSI2,
    HWRITESI2,
    HSIZESI2,
    HBURSTSI2,
    HPROTSI2,
    HMASTERSI2,
    HWDATASI2,
    HMASTLOCKSI2,
    HREADYSI2,
    HAUSERSI2,
    HWUSERSI2,

    // Output port MI0 (inputs from slave 0)
    HRDATAMI0,
    HREADYOUTMI0,
    HRESPMI0,
    HRUSERMI0,

    // Output port MI1 (inputs from slave 1)
    HRDATAMI1,
    HREADYOUTMI1,
    HRESPMI1,
    HRUSERMI1,

    // Output port MI2 (inputs from slave 2)
    HRDATAMI2,
    HREADYOUTMI2,
    HRESPMI2,
    HRUSERMI2,

    // Scan test dummy signals; not connected until scan insertion
    SCANENABLE,   // Scan Test Mode Enable
    SCANINHCLK,   // Scan Chain Input


    // Output port MI0 (outputs to slave 0)
    HSELMI0,
    HADDRMI0,
    HTRANSMI0,
    HWRITEMI0,
    HSIZEMI0,
    HBURSTMI0,
    HPROTMI0,
    HMASTERMI0,
    HWDATAMI0,
    HMASTLOCKMI0,
    HREADYMUXMI0,
    HAUSERMI0,
    HWUSERMI0,

    // Output port MI1 (outputs to slave 1)
    HSELMI1,
    HADDRMI1,
    HTRANSMI1,
    HWRITEMI1,
    HSIZEMI1,
    HBURSTMI1,
    HPROTMI1,
    HMASTERMI1,
    HWDATAMI1,
    HMASTLOCKMI1,
    HREADYMUXMI1,
    HAUSERMI1,
    HWUSERMI1,

    // Output port MI2 (outputs to slave 2)
    HSELMI2,
    HADDRMI2,
    HTRANSMI2,
    HWRITEMI2,
    HSIZEMI2,
    HBURSTMI2,
    HPROTMI2,
    HMASTERMI2,
    HWDATAMI2,
    HMASTLOCKMI2,
    HREADYMUXMI2,
    HAUSERMI2,
    HWUSERMI2,

    // Input port SI0 (outputs to master 0)
    HRDATASI0,
    HREADYOUTSI0,
    HRESPSI0,
    HRUSERSI0,

    // Input port SI1 (outputs to master 1)
    HRDATASI1,
    HREADYOUTSI1,
    HRESPSI1,
    HRUSERSI1,

    // Input port SI2 (outputs to master 2)
    HRDATASI2,
    HREADYOUTSI2,
    HRESPSI2,
    HRUSERSI2,

    // Scan test dummy signals; not connected until scan insertion
    SCANOUTHCLK   // Scan Chain Output

    );


// -----------------------------------------------------------------------------
// Input and Output declarations
// -----------------------------------------------------------------------------

    // Common AHB signals
    input         HCLK;            // AHB System Clock
    input         HRESETn;         // AHB System Reset

    // System address remapping control
    input   [3:0] REMAP;           // REMAP input

    // Input port SI0 (inputs from master 0)
    input         HSELSI0;          // Slave Select
    input  [31:0] HADDRSI0;         // Address bus
    input   [1:0] HTRANSSI0;        // Transfer type
    input         HWRITESI0;        // Transfer direction
    input   [2:0] HSIZESI0;         // Transfer size
    input   [2:0] HBURSTSI0;        // Burst type
    input   [3:0] HPROTSI0;         // Protection control
    input   [3:0] HMASTERSI0;       // Master select
    input  [31:0] HWDATASI0;        // Write data
    input         HMASTLOCKSI0;     // Locked Sequence
    input         HREADYSI0;        // Transfer done
    input  [31:0] HAUSERSI0;        // Address USER signals
    input  [31:0] HWUSERSI0;        // Write-data USER signals

    // Input port SI1 (inputs from master 1)
    input         HSELSI1;          // Slave Select
    input  [31:0] HADDRSI1;         // Address bus
    input   [1:0] HTRANSSI1;        // Transfer type
    input         HWRITESI1;        // Transfer direction
    input   [2:0] HSIZESI1;         // Transfer size
    input   [2:0] HBURSTSI1;        // Burst type
    input   [3:0] HPROTSI1;         // Protection control
    input   [3:0] HMASTERSI1;       // Master select
    input  [31:0] HWDATASI1;        // Write data
    input         HMASTLOCKSI1;     // Locked Sequence
    input         HREADYSI1;        // Transfer done
    input  [31:0] HAUSERSI1;        // Address USER signals
    input  [31:0] HWUSERSI1;        // Write-data USER signals

    // Input port SI2 (inputs from master 2)
    input         HSELSI2;          // Slave Select
    input  [31:0] HADDRSI2;         // Address bus
    input   [1:0] HTRANSSI2;        // Transfer type
    input         HWRITESI2;        // Transfer direction
    input   [2:0] HSIZESI2;         // Transfer size
    input   [2:0] HBURSTSI2;        // Burst type
    input   [3:0] HPROTSI2;         // Protection control
    input   [3:0] HMASTERSI2;       // Master select
    input  [31:0] HWDATASI2;        // Write data
    input         HMASTLOCKSI2;     // Locked Sequence
    input         HREADYSI2;        // Transfer done
    input  [31:0] HAUSERSI2;        // Address USER signals
    input  [31:0] HWUSERSI2;        // Write-data USER signals

    // Output port MI0 (inputs from slave 0)
    input  [31:0] HRDATAMI0;        // Read data bus
    input         HREADYOUTMI0;     // HREADY feedback
    input   [1:0] HRESPMI0;         // Transfer response
    input  [31:0] HRUSERMI0;        // Read-data USER signals

    // Output port MI1 (inputs from slave 1)
    input  [31:0] HRDATAMI1;        // Read data bus
    input         HREADYOUTMI1;     // HREADY feedback
    input   [1:0] HRESPMI1;         // Transfer response
    input  [31:0] HRUSERMI1;        // Read-data USER signals

    // Output port MI2 (inputs from slave 2)
    input  [31:0] HRDATAMI2;        // Read data bus
    input         HREADYOUTMI2;     // HREADY feedback
    input   [1:0] HRESPMI2;         // Transfer response
    input  [31:0] HRUSERMI2;        // Read-data USER signals

    // Scan test dummy signals; not connected until scan insertion
    input         SCANENABLE;      // Scan enable signal
    input         SCANINHCLK;      // HCLK scan input


    // Output port MI0 (outputs to slave 0)
    output        HSELMI0;          // Slave Select
    output [31:0] HADDRMI0;         // Address bus
    output  [1:0] HTRANSMI0;        // Transfer type
    output        HWRITEMI0;        // Transfer direction
    output  [2:0] HSIZEMI0;         // Transfer size
    output  [2:0] HBURSTMI0;        // Burst type
    output  [3:0] HPROTMI0;         // Protection control
    output  [3:0] HMASTERMI0;       // Master select
    output [31:0] HWDATAMI0;        // Write data
    output        HMASTLOCKMI0;     // Locked Sequence
    output        HREADYMUXMI0;     // Transfer done
    output [31:0] HAUSERMI0;        // Address USER signals
    output [31:0] HWUSERMI0;        // Write-data USER signals

    // Output port MI1 (outputs to slave 1)
    output        HSELMI1;          // Slave Select
    output [31:0] HADDRMI1;         // Address bus
    output  [1:0] HTRANSMI1;        // Transfer type
    output        HWRITEMI1;        // Transfer direction
    output  [2:0] HSIZEMI1;         // Transfer size
    output  [2:0] HBURSTMI1;        // Burst type
    output  [3:0] HPROTMI1;         // Protection control
    output  [3:0] HMASTERMI1;       // Master select
    output [31:0] HWDATAMI1;        // Write data
    output        HMASTLOCKMI1;     // Locked Sequence
    output        HREADYMUXMI1;     // Transfer done
    output [31:0] HAUSERMI1;        // Address USER signals
    output [31:0] HWUSERMI1;        // Write-data USER signals

    // Output port MI2 (outputs to slave 2)
    output        HSELMI2;          // Slave Select
    output [31:0] HADDRMI2;         // Address bus
    output  [1:0] HTRANSMI2;        // Transfer type
    output        HWRITEMI2;        // Transfer direction
    output  [2:0] HSIZEMI2;         // Transfer size
    output  [2:0] HBURSTMI2;        // Burst type
    output  [3:0] HPROTMI2;         // Protection control
    output  [3:0] HMASTERMI2;       // Master select
    output [31:0] HWDATAMI2;        // Write data
    output        HMASTLOCKMI2;     // Locked Sequence
    output        HREADYMUXMI2;     // Transfer done
    output [31:0] HAUSERMI2;        // Address USER signals
    output [31:0] HWUSERMI2;        // Write-data USER signals

    // Input port SI0 (outputs to master 0)
    output [31:0] HRDATASI0;        // Read data bus
    output        HREADYOUTSI0;     // HREADY feedback
    output  [1:0] HRESPSI0;         // Transfer response
    output [31:0] HRUSERSI0;        // Read-data USER signals

    // Input port SI1 (outputs to master 1)
    output [31:0] HRDATASI1;        // Read data bus
    output        HREADYOUTSI1;     // HREADY feedback
    output  [1:0] HRESPSI1;         // Transfer response
    output [31:0] HRUSERSI1;        // Read-data USER signals

    // Input port SI2 (outputs to master 2)
    output [31:0] HRDATASI2;        // Read data bus
    output        HREADYOUTSI2;     // HREADY feedback
    output  [1:0] HRESPSI2;         // Transfer response
    output [31:0] HRUSERSI2;        // Read-data USER signals

    // Scan test dummy signals; not connected until scan insertion
    output        SCANOUTHCLK;     // Scan Chain Output


// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

    // Common AHB signals
    wire         HCLK;            // AHB System Clock
    wire         HRESETn;         // AHB System Reset

    // System address remapping control
    wire   [3:0] REMAP;           // REMAP signal

    // Input Port SI0
    wire         HSELSI0;          // Slave Select
    wire  [31:0] HADDRSI0;         // Address bus
    wire   [1:0] HTRANSSI0;        // Transfer type
    wire         HWRITESI0;        // Transfer direction
    wire   [2:0] HSIZESI0;         // Transfer size
    wire   [2:0] HBURSTSI0;        // Burst type
    wire   [3:0] HPROTSI0;         // Protection control
    wire   [3:0] HMASTERSI0;       // Master select
    wire  [31:0] HWDATASI0;        // Write data
    wire         HMASTLOCKSI0;     // Locked Sequence
    wire         HREADYSI0;        // Transfer done

    wire  [31:0] HRDATASI0;        // Read data bus
    wire         HREADYOUTSI0;     // HREADY feedback
    wire   [1:0] HRESPSI0;         // Transfer response
    wire  [31:0] HAUSERSI0;        // Address USER signals
    wire  [31:0] HWUSERSI0;        // Write-data USER signals
    wire  [31:0] HRUSERSI0;        // Read-data USER signals

    // Input Port SI1
    wire         HSELSI1;          // Slave Select
    wire  [31:0] HADDRSI1;         // Address bus
    wire   [1:0] HTRANSSI1;        // Transfer type
    wire         HWRITESI1;        // Transfer direction
    wire   [2:0] HSIZESI1;         // Transfer size
    wire   [2:0] HBURSTSI1;        // Burst type
    wire   [3:0] HPROTSI1;         // Protection control
    wire   [3:0] HMASTERSI1;       // Master select
    wire  [31:0] HWDATASI1;        // Write data
    wire         HMASTLOCKSI1;     // Locked Sequence
    wire         HREADYSI1;        // Transfer done

    wire  [31:0] HRDATASI1;        // Read data bus
    wire         HREADYOUTSI1;     // HREADY feedback
    wire   [1:0] HRESPSI1;         // Transfer response
    wire  [31:0] HAUSERSI1;        // Address USER signals
    wire  [31:0] HWUSERSI1;        // Write-data USER signals
    wire  [31:0] HRUSERSI1;        // Read-data USER signals

    // Input Port SI2
    wire         HSELSI2;          // Slave Select
    wire  [31:0] HADDRSI2;         // Address bus
    wire   [1:0] HTRANSSI2;        // Transfer type
    wire         HWRITESI2;        // Transfer direction
    wire   [2:0] HSIZESI2;         // Transfer size
    wire   [2:0] HBURSTSI2;        // Burst type
    wire   [3:0] HPROTSI2;         // Protection control
    wire   [3:0] HMASTERSI2;       // Master select
    wire  [31:0] HWDATASI2;        // Write data
    wire         HMASTLOCKSI2;     // Locked Sequence
    wire         HREADYSI2;        // Transfer done

    wire  [31:0] HRDATASI2;        // Read data bus
    wire         HREADYOUTSI2;     // HREADY feedback
    wire   [1:0] HRESPSI2;         // Transfer response
    wire  [31:0] HAUSERSI2;        // Address USER signals
    wire  [31:0] HWUSERSI2;        // Write-data USER signals
    wire  [31:0] HRUSERSI2;        // Read-data USER signals

    // Output Port MI0
    wire         HSELMI0;          // Slave Select
    wire  [31:0] HADDRMI0;         // Address bus
    wire   [1:0] HTRANSMI0;        // Transfer type
    wire         HWRITEMI0;        // Transfer direction
    wire   [2:0] HSIZEMI0;         // Transfer size
    wire   [2:0] HBURSTMI0;        // Burst type
    wire   [3:0] HPROTMI0;         // Protection control
    wire   [3:0] HMASTERMI0;       // Master select
    wire  [31:0] HWDATAMI0;        // Write data
    wire         HMASTLOCKMI0;     // Locked Sequence
    wire         HREADYMUXMI0;     // Transfer done

    wire  [31:0] HRDATAMI0;        // Read data bus
    wire         HREADYOUTMI0;     // HREADY feedback
    wire   [1:0] HRESPMI0;         // Transfer response
    wire  [31:0] HAUSERMI0;        // Address USER signals
    wire  [31:0] HWUSERMI0;        // Write-data USER signals
    wire  [31:0] HRUSERMI0;        // Read-data USER signals

    // Output Port MI1
    wire         HSELMI1;          // Slave Select
    wire  [31:0] HADDRMI1;         // Address bus
    wire   [1:0] HTRANSMI1;        // Transfer type
    wire         HWRITEMI1;        // Transfer direction
    wire   [2:0] HSIZEMI1;         // Transfer size
    wire   [2:0] HBURSTMI1;        // Burst type
    wire   [3:0] HPROTMI1;         // Protection control
    wire   [3:0] HMASTERMI1;       // Master select
    wire  [31:0] HWDATAMI1;        // Write data
    wire         HMASTLOCKMI1;     // Locked Sequence
    wire         HREADYMUXMI1;     // Transfer done

    wire  [31:0] HRDATAMI1;        // Read data bus
    wire         HREADYOUTMI1;     // HREADY feedback
    wire   [1:0] HRESPMI1;         // Transfer response
    wire  [31:0] HAUSERMI1;        // Address USER signals
    wire  [31:0] HWUSERMI1;        // Write-data USER signals
    wire  [31:0] HRUSERMI1;        // Read-data USER signals

    // Output Port MI2
    wire         HSELMI2;          // Slave Select
    wire  [31:0] HADDRMI2;         // Address bus
    wire   [1:0] HTRANSMI2;        // Transfer type
    wire         HWRITEMI2;        // Transfer direction
    wire   [2:0] HSIZEMI2;         // Transfer size
    wire   [2:0] HBURSTMI2;        // Burst type
    wire   [3:0] HPROTMI2;         // Protection control
    wire   [3:0] HMASTERMI2;       // Master select
    wire  [31:0] HWDATAMI2;        // Write data
    wire         HMASTLOCKMI2;     // Locked Sequence
    wire         HREADYMUXMI2;     // Transfer done

    wire  [31:0] HRDATAMI2;        // Read data bus
    wire         HREADYOUTMI2;     // HREADY feedback
    wire   [1:0] HRESPMI2;         // Transfer response
    wire  [31:0] HAUSERMI2;        // Address USER signals
    wire  [31:0] HWUSERMI2;        // Write-data USER signals
    wire  [31:0] HRUSERMI2;        // Read-data USER signals


// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------

    // Bus-switch input SI0
    wire         i_sel0;            // HSEL signal
    wire  [31:0] i_addr0;           // HADDR signal
    wire   [1:0] i_trans0;          // HTRANS signal
    wire         i_write0;          // HWRITE signal
    wire   [2:0] i_size0;           // HSIZE signal
    wire   [2:0] i_burst0;          // HBURST signal
    wire   [3:0] i_prot0;           // HPROTS signal
    wire   [3:0] i_master0;         // HMASTER signal
    wire         i_mastlock0;       // HMASTLOCK signal
    wire         i_active0;         // Active signal
    wire         i_held_tran0;       // HeldTran signal
    wire         i_readyout0;       // Readyout signal
    wire   [1:0] i_resp0;           // Response signal
    wire  [31:0] i_auser0;          // HAUSER signal

    // Bus-switch input SI1
    wire         i_sel1;            // HSEL signal
    wire  [31:0] i_addr1;           // HADDR signal
    wire   [1:0] i_trans1;          // HTRANS signal
    wire         i_write1;          // HWRITE signal
    wire   [2:0] i_size1;           // HSIZE signal
    wire   [2:0] i_burst1;          // HBURST signal
    wire   [3:0] i_prot1;           // HPROTS signal
    wire   [3:0] i_master1;         // HMASTER signal
    wire         i_mastlock1;       // HMASTLOCK signal
    wire         i_active1;         // Active signal
    wire         i_held_tran1;       // HeldTran signal
    wire         i_readyout1;       // Readyout signal
    wire   [1:0] i_resp1;           // Response signal
    wire  [31:0] i_auser1;          // HAUSER signal

    // Bus-switch input SI2
    wire         i_sel2;            // HSEL signal
    wire  [31:0] i_addr2;           // HADDR signal
    wire   [1:0] i_trans2;          // HTRANS signal
    wire         i_write2;          // HWRITE signal
    wire   [2:0] i_size2;           // HSIZE signal
    wire   [2:0] i_burst2;          // HBURST signal
    wire   [3:0] i_prot2;           // HPROTS signal
    wire   [3:0] i_master2;         // HMASTER signal
    wire         i_mastlock2;       // HMASTLOCK signal
    wire         i_active2;         // Active signal
    wire         i_held_tran2;       // HeldTran signal
    wire         i_readyout2;       // Readyout signal
    wire   [1:0] i_resp2;           // Response signal
    wire  [31:0] i_auser2;          // HAUSER signal

    // Bus-switch SI0 to MI0 signals
    wire         i_sel0to0;         // Routing selection signal
    wire         i_active0to0;      // Active signal

    // Bus-switch SI0 to MI1 signals
    wire         i_sel0to1;         // Routing selection signal
    wire         i_active0to1;      // Active signal

    // Bus-switch SI0 to MI2 signals
    wire         i_sel0to2;         // Routing selection signal
    wire         i_active0to2;      // Active signal

    // Bus-switch SI1 to MI0 signals
    wire         i_sel1to0;         // Routing selection signal
    wire         i_active1to0;      // Active signal

    // Bus-switch SI1 to MI1 signals
    wire         i_sel1to1;         // Routing selection signal
    wire         i_active1to1;      // Active signal

    // Bus-switch SI1 to MI2 signals
    wire         i_sel1to2;         // Routing selection signal
    wire         i_active1to2;      // Active signal

    // Bus-switch SI2 to MI0 signals
    wire         i_sel2to0;         // Routing selection signal
    wire         i_active2to0;      // Active signal

    // Bus-switch SI2 to MI1 signals
    wire         i_sel2to1;         // Routing selection signal
    wire         i_active2to1;      // Active signal

    // Bus-switch SI2 to MI2 signals
    wire         i_sel2to2;         // Routing selection signal
    wire         i_active2to2;      // Active signal

    wire         i_hready_mux_mi0;    // Internal HREADYMUXM for MI0
    wire         i_hready_mux_mi1;    // Internal HREADYMUXM for MI1
    wire         i_hready_mux_mi2;    // Internal HREADYMUXM for MI2


// -----------------------------------------------------------------------------
// Beginning of main code
// -----------------------------------------------------------------------------

  // Input stage for SI0
  InputStage u_InputStage_0 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELSI0),
    .HADDRS     (HADDRSI0),
    .HTRANSS    (HTRANSSI0),
    .HWRITES    (HWRITESI0),
    .HSIZES     (HSIZESI0),
    .HBURSTS    (HBURSTSI0),
    .HPROTS     (HPROTSI0),
    .HMASTERS   (HMASTERSI0),
    .HMASTLOCKS (HMASTLOCKSI0),
    .HREADYS    (HREADYSI0),
    .HAUSERS    (HAUSERSI0),

    // Internal Response
    .active_ip     (i_active0),
    .readyout_ip   (i_readyout0),
    .resp_ip       (i_resp0),

    // Input Port Response
    .HREADYOUTS (HREADYOUTSI0),
    .HRESPS     (HRESPSI0),

    // Internal Address/Control Signals
    .sel_ip        (i_sel0),
    .addr_ip       (i_addr0),
    .auser_ip      (i_auser0),
    .trans_ip      (i_trans0),
    .write_ip      (i_write0),
    .size_ip       (i_size0),
    .burst_ip      (i_burst0),
    .prot_ip       (i_prot0),
    .master_ip     (i_master0),
    .mastlock_ip   (i_mastlock0),
    .held_tran_ip   (i_held_tran0)

    );


  // Input stage for SI1
  InputStage u_InputStage_1 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELSI1),
    .HADDRS     (HADDRSI1),
    .HTRANSS    (HTRANSSI1),
    .HWRITES    (HWRITESI1),
    .HSIZES     (HSIZESI1),
    .HBURSTS    (HBURSTSI1),
    .HPROTS     (HPROTSI1),
    .HMASTERS   (HMASTERSI1),
    .HMASTLOCKS (HMASTLOCKSI1),
    .HREADYS    (HREADYSI1),
    .HAUSERS    (HAUSERSI1),

    // Internal Response
    .active_ip     (i_active1),
    .readyout_ip   (i_readyout1),
    .resp_ip       (i_resp1),

    // Input Port Response
    .HREADYOUTS (HREADYOUTSI1),
    .HRESPS     (HRESPSI1),

    // Internal Address/Control Signals
    .sel_ip        (i_sel1),
    .addr_ip       (i_addr1),
    .auser_ip      (i_auser1),
    .trans_ip      (i_trans1),
    .write_ip      (i_write1),
    .size_ip       (i_size1),
    .burst_ip      (i_burst1),
    .prot_ip       (i_prot1),
    .master_ip     (i_master1),
    .mastlock_ip   (i_mastlock1),
    .held_tran_ip   (i_held_tran1)

    );


  // Input stage for SI2
  InputStage u_InputStage_2 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELSI2),
    .HADDRS     (HADDRSI2),
    .HTRANSS    (HTRANSSI2),
    .HWRITES    (HWRITESI2),
    .HSIZES     (HSIZESI2),
    .HBURSTS    (HBURSTSI2),
    .HPROTS     (HPROTSI2),
    .HMASTERS   (HMASTERSI2),
    .HMASTLOCKS (HMASTLOCKSI2),
    .HREADYS    (HREADYSI2),
    .HAUSERS    (HAUSERSI2),

    // Internal Response
    .active_ip     (i_active2),
    .readyout_ip   (i_readyout2),
    .resp_ip       (i_resp2),

    // Input Port Response
    .HREADYOUTS (HREADYOUTSI2),
    .HRESPS     (HRESPSI2),

    // Internal Address/Control Signals
    .sel_ip        (i_sel2),
    .addr_ip       (i_addr2),
    .auser_ip      (i_auser2),
    .trans_ip      (i_trans2),
    .write_ip      (i_write2),
    .size_ip       (i_size2),
    .burst_ip      (i_burst2),
    .prot_ip       (i_prot2),
    .master_ip     (i_master2),
    .mastlock_ip   (i_mastlock2),
    .held_tran_ip   (i_held_tran2)

    );


  // Matrix decoder for SI0
  cmsdk_ahb_bm_decodeSI0 u_cmsdk_ahb_bm_decodesi0 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Signals from Input stage SI0
    .HREADYS    (HREADYSI0),
    .sel_dec        (i_sel0),
    .decode_addr_dec (i_addr0[31:10]),   // HADDR[9:0] is not decoded
    .trans_dec      (i_trans0),

    // Control/Response for Output Stage MI0
    .active_dec0    (i_active0to0),
    .readyout_dec0  (i_hready_mux_mi0),
    .resp_dec0      (HRESPMI0),
    .rdata_dec0     (HRDATAMI0),
    .ruser_dec0     (HRUSERMI0),

    // Control/Response for Output Stage MI1
    .active_dec1    (i_active0to1),
    .readyout_dec1  (i_hready_mux_mi1),
    .resp_dec1      (HRESPMI1),
    .rdata_dec1     (HRDATAMI1),
    .ruser_dec1     (HRUSERMI1),

    // Control/Response for Output Stage MI2
    .active_dec2    (i_active0to2),
    .readyout_dec2  (i_hready_mux_mi2),
    .resp_dec2      (HRESPMI2),
    .rdata_dec2     (HRDATAMI2),
    .ruser_dec2     (HRUSERMI2),

    .sel_dec0       (i_sel0to0),
    .sel_dec1       (i_sel0to1),
    .sel_dec2       (i_sel0to2),

    .active_dec     (i_active0),
    .HREADYOUTS (i_readyout0),
    .HRESPS     (i_resp0),
    .HRUSERS    (HRUSERSI0),
    .HRDATAS    (HRDATASI0)

    );


  // Matrix decoder for SI1
  cmsdk_ahb_bm_decodeSI1 u_cmsdk_ahb_bm_decodesi1 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Signals from Input stage SI1
    .HREADYS    (HREADYSI1),
    .sel_dec        (i_sel1),
    .decode_addr_dec (i_addr1[31:10]),   // HADDR[9:0] is not decoded
    .trans_dec      (i_trans1),

    // Control/Response for Output Stage MI0
    .active_dec0    (i_active1to0),
    .readyout_dec0  (i_hready_mux_mi0),
    .resp_dec0      (HRESPMI0),
    .rdata_dec0     (HRDATAMI0),
    .ruser_dec0     (HRUSERMI0),

    // Control/Response for Output Stage MI1
    .active_dec1    (i_active1to1),
    .readyout_dec1  (i_hready_mux_mi1),
    .resp_dec1      (HRESPMI1),
    .rdata_dec1     (HRDATAMI1),
    .ruser_dec1     (HRUSERMI1),

    // Control/Response for Output Stage MI2
    .active_dec2    (i_active1to2),
    .readyout_dec2  (i_hready_mux_mi2),
    .resp_dec2      (HRESPMI2),
    .rdata_dec2     (HRDATAMI2),
    .ruser_dec2     (HRUSERMI2),

    .sel_dec0       (i_sel1to0),
    .sel_dec1       (i_sel1to1),
    .sel_dec2       (i_sel1to2),

    .active_dec     (i_active1),
    .HREADYOUTS (i_readyout1),
    .HRESPS     (i_resp1),
    .HRUSERS    (HRUSERSI1),
    .HRDATAS    (HRDATASI1)

    );


  // Matrix decoder for SI2
  cmsdk_ahb_bm_decodeSI2 u_cmsdk_ahb_bm_decodesi2 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Signals from Input stage SI2
    .HREADYS    (HREADYSI2),
    .sel_dec        (i_sel2),
    .decode_addr_dec (i_addr2[31:10]),   // HADDR[9:0] is not decoded
    .trans_dec      (i_trans2),

    // Control/Response for Output Stage MI0
    .active_dec0    (i_active2to0),
    .readyout_dec0  (i_hready_mux_mi0),
    .resp_dec0      (HRESPMI0),
    .rdata_dec0     (HRDATAMI0),
    .ruser_dec0     (HRUSERMI0),

    // Control/Response for Output Stage MI1
    .active_dec1    (i_active2to1),
    .readyout_dec1  (i_hready_mux_mi1),
    .resp_dec1      (HRESPMI1),
    .rdata_dec1     (HRDATAMI1),
    .ruser_dec1     (HRUSERMI1),

    // Control/Response for Output Stage MI2
    .active_dec2    (i_active2to2),
    .readyout_dec2  (i_hready_mux_mi2),
    .resp_dec2      (HRESPMI2),
    .rdata_dec2     (HRDATAMI2),
    .ruser_dec2     (HRUSERMI2),

    .sel_dec0       (i_sel2to0),
    .sel_dec1       (i_sel2to1),
    .sel_dec2       (i_sel2to2),

    .active_dec     (i_active2),
    .HREADYOUTS (i_readyout2),
    .HRESPS     (i_resp2),
    .HRUSERS    (HRUSERSI2),
    .HRDATAS    (HRDATASI2)

    );


  // Output stage for MI0
  OutputStage u_outputstage_0 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 0 Signals
    .sel_op0       (i_sel0to0),
    .addr_op0      (i_addr0),
    .auser_op0     (i_auser0),
    .trans_op0     (i_trans0),
    .write_op0     (i_write0),
    .size_op0      (i_size0),
    .burst_op0     (i_burst0),
    .prot_op0      (i_prot0),
    .master_op0    (i_master0),
    .mastlock_op0  (i_mastlock0),
    .wdata_op0     (HWDATASI0),
    .wuser_op0     (HWUSERSI0),
    .held_tran_op0  (i_held_tran0),

    // Port 1 Signals
    .sel_op1       (i_sel1to0),
    .addr_op1      (i_addr1),
    .auser_op1     (i_auser1),
    .trans_op1     (i_trans1),
    .write_op1     (i_write1),
    .size_op1      (i_size1),
    .burst_op1     (i_burst1),
    .prot_op1      (i_prot1),
    .master_op1    (i_master1),
    .mastlock_op1  (i_mastlock1),
    .wdata_op1     (HWDATASI1),
    .wuser_op1     (HWUSERSI1),
    .held_tran_op1  (i_held_tran1),

    // Port 2 Signals
    .sel_op2       (i_sel2to0),
    .addr_op2      (i_addr2),
    .auser_op2     (i_auser2),
    .trans_op2     (i_trans2),
    .write_op2     (i_write2),
    .size_op2      (i_size2),
    .burst_op2     (i_burst2),
    .prot_op2      (i_prot2),
    .master_op2    (i_master2),
    .mastlock_op2  (i_mastlock2),
    .wdata_op2     (HWDATASI2),
    .wuser_op2     (HWUSERSI2),
    .held_tran_op2  (i_held_tran2),

    // Slave read data and response
    .HREADYOUTM (HREADYOUTMI0),

    .active_op0    (i_active0to0),
    .active_op1    (i_active1to0),
    .active_op2    (i_active2to0),

    // Slave Address/Control Signals
    .HSELM      (HSELMI0),
    .HADDRM     (HADDRMI0),
    .HAUSERM    (HAUSERMI0),
    .HTRANSM    (HTRANSMI0),
    .HWRITEM    (HWRITEMI0),
    .HSIZEM     (HSIZEMI0),
    .HBURSTM    (HBURSTMI0),
    .HPROTM     (HPROTMI0),
    .HMASTERM   (HMASTERMI0),
    .HMASTLOCKM (HMASTLOCKMI0),
    .HREADYMUXM (i_hready_mux_mi0),
    .HWUSERM    (HWUSERMI0),
    .HWDATAM    (HWDATAMI0)

    );

  // Drive output with internal version
  assign HREADYMUXMI0 = i_hready_mux_mi0;


  // Output stage for MI1
  OutputStage u_outputstage_1 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 0 Signals
    .sel_op0       (i_sel0to1),
    .addr_op0      (i_addr0),
    .auser_op0     (i_auser0),
    .trans_op0     (i_trans0),
    .write_op0     (i_write0),
    .size_op0      (i_size0),
    .burst_op0     (i_burst0),
    .prot_op0      (i_prot0),
    .master_op0    (i_master0),
    .mastlock_op0  (i_mastlock0),
    .wdata_op0     (HWDATASI0),
    .wuser_op0     (HWUSERSI0),
    .held_tran_op0  (i_held_tran0),

    // Port 1 Signals
    .sel_op1       (i_sel1to1),
    .addr_op1      (i_addr1),
    .auser_op1     (i_auser1),
    .trans_op1     (i_trans1),
    .write_op1     (i_write1),
    .size_op1      (i_size1),
    .burst_op1     (i_burst1),
    .prot_op1      (i_prot1),
    .master_op1    (i_master1),
    .mastlock_op1  (i_mastlock1),
    .wdata_op1     (HWDATASI1),
    .wuser_op1     (HWUSERSI1),
    .held_tran_op1  (i_held_tran1),

    // Port 2 Signals
    .sel_op2       (i_sel2to1),
    .addr_op2      (i_addr2),
    .auser_op2     (i_auser2),
    .trans_op2     (i_trans2),
    .write_op2     (i_write2),
    .size_op2      (i_size2),
    .burst_op2     (i_burst2),
    .prot_op2      (i_prot2),
    .master_op2    (i_master2),
    .mastlock_op2  (i_mastlock2),
    .wdata_op2     (HWDATASI2),
    .wuser_op2     (HWUSERSI2),
    .held_tran_op2  (i_held_tran2),

    // Slave read data and response
    .HREADYOUTM (HREADYOUTMI1),

    .active_op0    (i_active0to1),
    .active_op1    (i_active1to1),
    .active_op2    (i_active2to1),

    // Slave Address/Control Signals
    .HSELM      (HSELMI1),
    .HADDRM     (HADDRMI1),
    .HAUSERM    (HAUSERMI1),
    .HTRANSM    (HTRANSMI1),
    .HWRITEM    (HWRITEMI1),
    .HSIZEM     (HSIZEMI1),
    .HBURSTM    (HBURSTMI1),
    .HPROTM     (HPROTMI1),
    .HMASTERM   (HMASTERMI1),
    .HMASTLOCKM (HMASTLOCKMI1),
    .HREADYMUXM (i_hready_mux_mi1),
    .HWUSERM    (HWUSERMI1),
    .HWDATAM    (HWDATAMI1)

    );

  // Drive output with internal version
  assign HREADYMUXMI1 = i_hready_mux_mi1;


  // Output stage for MI2
  OutputStage u_outputstage_2 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 0 Signals
    .sel_op0       (i_sel0to2),
    .addr_op0      (i_addr0),
    .auser_op0     (i_auser0),
    .trans_op0     (i_trans0),
    .write_op0     (i_write0),
    .size_op0      (i_size0),
    .burst_op0     (i_burst0),
    .prot_op0      (i_prot0),
    .master_op0    (i_master0),
    .mastlock_op0  (i_mastlock0),
    .wdata_op0     (HWDATASI0),
    .wuser_op0     (HWUSERSI0),
    .held_tran_op0  (i_held_tran0),

    // Port 1 Signals
    .sel_op1       (i_sel1to2),
    .addr_op1      (i_addr1),
    .auser_op1     (i_auser1),
    .trans_op1     (i_trans1),
    .write_op1     (i_write1),
    .size_op1      (i_size1),
    .burst_op1     (i_burst1),
    .prot_op1      (i_prot1),
    .master_op1    (i_master1),
    .mastlock_op1  (i_mastlock1),
    .wdata_op1     (HWDATASI1),
    .wuser_op1     (HWUSERSI1),
    .held_tran_op1  (i_held_tran1),

    // Port 2 Signals
    .sel_op2       (i_sel2to2),
    .addr_op2      (i_addr2),
    .auser_op2     (i_auser2),
    .trans_op2     (i_trans2),
    .write_op2     (i_write2),
    .size_op2      (i_size2),
    .burst_op2     (i_burst2),
    .prot_op2      (i_prot2),
    .master_op2    (i_master2),
    .mastlock_op2  (i_mastlock2),
    .wdata_op2     (HWDATASI2),
    .wuser_op2     (HWUSERSI2),
    .held_tran_op2  (i_held_tran2),

    // Slave read data and response
    .HREADYOUTM (HREADYOUTMI2),

    .active_op0    (i_active0to2),
    .active_op1    (i_active1to2),
    .active_op2    (i_active2to2),

    // Slave Address/Control Signals
    .HSELM      (HSELMI2),
    .HADDRM     (HADDRMI2),
    .HAUSERM    (HAUSERMI2),
    .HTRANSM    (HTRANSMI2),
    .HWRITEM    (HWRITEMI2),
    .HSIZEM     (HSIZEMI2),
    .HBURSTM    (HBURSTMI2),
    .HPROTM     (HPROTMI2),
    .HMASTERM   (HMASTERMI2),
    .HMASTLOCKM (HMASTLOCKMI2),
    .HREADYMUXM (i_hready_mux_mi2),
    .HWUSERM    (HWUSERMI2),
    .HWDATAM    (HWDATAMI2)

    );

  // Drive output with internal version
  assign HREADYMUXMI2 = i_hready_mux_mi2;


endmodule

// --================================= End ===================================--

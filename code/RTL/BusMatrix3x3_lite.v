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
//  Abstract            : BusMatrixLite is a wrapper module that wraps around
//                        the BusMatrix module to give AHB Lite compliant
//                        slave and master interfaces.
//
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

module BusMatrix3x3_lite (

    // Common AHB signals
    HCLK,
    HRESETn,

    // System Address Remap control
    REMAP,

    // Input port SI0 (inputs from master 0)
    HADDRSI0,
    HTRANSSI0,
    HWRITESI0,
    HSIZESI0,
    HBURSTSI0,
    HPROTSI0,
    HWDATASI0,
    HMASTLOCKSI0,
    HAUSERSI0,
    HWUSERSI0,

    // Input port SI1 (inputs from master 1)
    HADDRSI1,
    HTRANSSI1,
    HWRITESI1,
    HSIZESI1,
    HBURSTSI1,
    HPROTSI1,
    HWDATASI1,
    HMASTLOCKSI1,
    HAUSERSI1,
    HWUSERSI1,

    // Input port SI2 (inputs from master 2)
    HADDRSI2,
    HTRANSSI2,
    HWRITESI2,
    HSIZESI2,
    HBURSTSI2,
    HPROTSI2,
    HWDATASI2,
    HMASTLOCKSI2,
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
    HWDATAMI2,
    HMASTLOCKMI2,
    HREADYMUXMI2,
    HAUSERMI2,
    HWUSERMI2,

    // Input port SI0 (outputs to master 0)
    HRDATASI0,
    HREADYSI0,
    HRESPSI0,
    HRUSERSI0,

    // Input port SI1 (outputs to master 1)
    HRDATASI1,
    HREADYSI1,
    HRESPSI1,
    HRUSERSI1,

    // Input port SI2 (outputs to master 2)
    HRDATASI2,
    HREADYSI2,
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

    // System Address Remap control
    input   [3:0] REMAP;           // System Address REMAP control

    // Input port SI0 (inputs from master 0)
    input  [31:0] HADDRSI0;         // Address bus
    input   [1:0] HTRANSSI0;        // Transfer type
    input         HWRITESI0;        // Transfer direction
    input   [2:0] HSIZESI0;         // Transfer size
    input   [2:0] HBURSTSI0;        // Burst type
    input   [3:0] HPROTSI0;         // Protection control
    input  [31:0] HWDATASI0;        // Write data
    input         HMASTLOCKSI0;     // Locked Sequence
    input  [31:0] HAUSERSI0;        // Address USER signals
    input  [31:0] HWUSERSI0;        // Write-data USER signals

    // Input port SI1 (inputs from master 1)
    input  [31:0] HADDRSI1;         // Address bus
    input   [1:0] HTRANSSI1;        // Transfer type
    input         HWRITESI1;        // Transfer direction
    input   [2:0] HSIZESI1;         // Transfer size
    input   [2:0] HBURSTSI1;        // Burst type
    input   [3:0] HPROTSI1;         // Protection control
    input  [31:0] HWDATASI1;        // Write data
    input         HMASTLOCKSI1;     // Locked Sequence
    input  [31:0] HAUSERSI1;        // Address USER signals
    input  [31:0] HWUSERSI1;        // Write-data USER signals

    // Input port SI2 (inputs from master 2)
    input  [31:0] HADDRSI2;         // Address bus
    input   [1:0] HTRANSSI2;        // Transfer type
    input         HWRITESI2;        // Transfer direction
    input   [2:0] HSIZESI2;         // Transfer size
    input   [2:0] HBURSTSI2;        // Burst type
    input   [3:0] HPROTSI2;         // Protection control
    input  [31:0] HWDATASI2;        // Write data
    input         HMASTLOCKSI2;     // Locked Sequence
    input  [31:0] HAUSERSI2;        // Address USER signals
    input  [31:0] HWUSERSI2;        // Write-data USER signals

    // Output port MI0 (inputs from slave 0)
    input  [31:0] HRDATAMI0;        // Read data bus
    input         HREADYOUTMI0;     // HREADY feedback
    input         HRESPMI0;         // Transfer response
    input  [31:0] HRUSERMI0;        // Read-data USER signals

    // Output port MI1 (inputs from slave 1)
    input  [31:0] HRDATAMI1;        // Read data bus
    input         HREADYOUTMI1;     // HREADY feedback
    input         HRESPMI1;         // Transfer response
    input  [31:0] HRUSERMI1;        // Read-data USER signals

    // Output port MI2 (inputs from slave 2)
    input  [31:0] HRDATAMI2;        // Read data bus
    input         HREADYOUTMI2;     // HREADY feedback
    input         HRESPMI2;         // Transfer response
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
    output [31:0] HWDATAMI2;        // Write data
    output        HMASTLOCKMI2;     // Locked Sequence
    output        HREADYMUXMI2;     // Transfer done
    output [31:0] HAUSERMI2;        // Address USER signals
    output [31:0] HWUSERMI2;        // Write-data USER signals

    // Input port SI0 (outputs to master 0)
    output [31:0] HRDATASI0;        // Read data bus
    output        HREADYSI0;     // HREADY feedback
    output        HRESPSI0;         // Transfer response
    output [31:0] HRUSERSI0;        // Read-data USER signals

    // Input port SI1 (outputs to master 1)
    output [31:0] HRDATASI1;        // Read data bus
    output        HREADYSI1;     // HREADY feedback
    output        HRESPSI1;         // Transfer response
    output [31:0] HRUSERSI1;        // Read-data USER signals

    // Input port SI2 (outputs to master 2)
    output [31:0] HRDATASI2;        // Read data bus
    output        HREADYSI2;     // HREADY feedback
    output        HRESPSI2;         // Transfer response
    output [31:0] HRUSERSI2;        // Read-data USER signals

    // Scan test dummy signals; not connected until scan insertion
    output        SCANOUTHCLK;     // Scan Chain Output

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

    // Common AHB signals
    wire         HCLK;            // AHB System Clock
    wire         HRESETn;         // AHB System Reset

    // System Address Remap control
    wire   [3:0] REMAP;           // System REMAP signal

    // Input Port SI0
    wire  [31:0] HADDRSI0;         // Address bus
    wire   [1:0] HTRANSSI0;        // Transfer type
    wire         HWRITESI0;        // Transfer direction
    wire   [2:0] HSIZESI0;         // Transfer size
    wire   [2:0] HBURSTSI0;        // Burst type
    wire   [3:0] HPROTSI0;         // Protection control
    wire  [31:0] HWDATASI0;        // Write data
    wire         HMASTLOCKSI0;     // Locked Sequence

    wire  [31:0] HRDATASI0;        // Read data bus
    wire         HREADYSI0;     // HREADY feedback
    wire         HRESPSI0;         // Transfer response
    wire  [31:0] HAUSERSI0;        // Address USER signals
    wire  [31:0] HWUSERSI0;        // Write-data USER signals
    wire  [31:0] HRUSERSI0;        // Read-data USER signals

    // Input Port SI1
    wire  [31:0] HADDRSI1;         // Address bus
    wire   [1:0] HTRANSSI1;        // Transfer type
    wire         HWRITESI1;        // Transfer direction
    wire   [2:0] HSIZESI1;         // Transfer size
    wire   [2:0] HBURSTSI1;        // Burst type
    wire   [3:0] HPROTSI1;         // Protection control
    wire  [31:0] HWDATASI1;        // Write data
    wire         HMASTLOCKSI1;     // Locked Sequence

    wire  [31:0] HRDATASI1;        // Read data bus
    wire         HREADYSI1;     // HREADY feedback
    wire         HRESPSI1;         // Transfer response
    wire  [31:0] HAUSERSI1;        // Address USER signals
    wire  [31:0] HWUSERSI1;        // Write-data USER signals
    wire  [31:0] HRUSERSI1;        // Read-data USER signals

    // Input Port SI2
    wire  [31:0] HADDRSI2;         // Address bus
    wire   [1:0] HTRANSSI2;        // Transfer type
    wire         HWRITESI2;        // Transfer direction
    wire   [2:0] HSIZESI2;         // Transfer size
    wire   [2:0] HBURSTSI2;        // Burst type
    wire   [3:0] HPROTSI2;         // Protection control
    wire  [31:0] HWDATASI2;        // Write data
    wire         HMASTLOCKSI2;     // Locked Sequence

    wire  [31:0] HRDATASI2;        // Read data bus
    wire         HREADYSI2;     // HREADY feedback
    wire         HRESPSI2;         // Transfer response
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
    wire  [31:0] HWDATAMI0;        // Write data
    wire         HMASTLOCKMI0;     // Locked Sequence
    wire         HREADYMUXMI0;     // Transfer done

    wire  [31:0] HRDATAMI0;        // Read data bus
    wire         HREADYOUTMI0;     // HREADY feedback
    wire         HRESPMI0;         // Transfer response
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
    wire  [31:0] HWDATAMI1;        // Write data
    wire         HMASTLOCKMI1;     // Locked Sequence
    wire         HREADYMUXMI1;     // Transfer done

    wire  [31:0] HRDATAMI1;        // Read data bus
    wire         HREADYOUTMI1;     // HREADY feedback
    wire         HRESPMI1;         // Transfer response
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
    wire  [31:0] HWDATAMI2;        // Write data
    wire         HMASTLOCKMI2;     // Locked Sequence
    wire         HREADYMUXMI2;     // Transfer done

    wire  [31:0] HRDATAMI2;        // Read data bus
    wire         HREADYOUTMI2;     // HREADY feedback
    wire         HRESPMI2;         // Transfer response
    wire  [31:0] HAUSERMI2;        // Address USER signals
    wire  [31:0] HWUSERMI2;        // Write-data USER signals
    wire  [31:0] HRUSERMI2;        // Read-data USER signals


// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------
    wire   [3:0] tie_hi_4;
    wire         tie_hi;
    wire         tie_low;
    wire   [1:0] i_hrespSI0;
    wire   [1:0] i_hrespSI1;
    wire   [1:0] i_hrespSI2;

    wire   [3:0]        i_hmasterMI0;
    wire   [1:0] i_hrespMI0;
    wire   [3:0]        i_hmasterMI1;
    wire   [1:0] i_hrespMI1;
    wire   [3:0]        i_hmasterMI2;
    wire   [1:0] i_hrespMI2;

// -----------------------------------------------------------------------------
// Beginning of main code
// -----------------------------------------------------------------------------

    assign tie_hi   = 1'b1;
    assign tie_hi_4 = 4'b1111;
    assign tie_low  = 1'b0;


    assign HRESPSI0  = i_hrespSI0[0];

    assign HRESPSI1  = i_hrespSI1[0];

    assign HRESPSI2  = i_hrespSI2[0];

    assign i_hrespMI0 = {tie_low, HRESPMI0};
    assign i_hrespMI1 = {tie_low, HRESPMI1};
    assign i_hrespMI2 = {tie_low, HRESPMI2};

// BusMatrix instance
  BusMatrix3x3 uBusMatrix3x3 (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .REMAP      (REMAP),

    // Input port SI0 signals
    .HSELSI0       (tie_hi),
    .HADDRSI0      (HADDRSI0),
    .HTRANSSI0     (HTRANSSI0),
    .HWRITESI0     (HWRITESI0),
    .HSIZESI0      (HSIZESI0),
    .HBURSTSI0     (HBURSTSI0),
    .HPROTSI0      (HPROTSI0),
    .HWDATASI0     (HWDATASI0),
    .HMASTLOCKSI0  (HMASTLOCKSI0),
    .HMASTERSI0    (tie_hi_4),
    .HREADYSI0     (HREADYSI0),
    .HAUSERSI0     (HAUSERSI0),
    .HWUSERSI0     (HWUSERSI0),
    .HRDATASI0     (HRDATASI0),
    .HREADYOUTSI0  (HREADYSI0),
    .HRESPSI0      (i_hrespSI0),
    .HRUSERSI0     (HRUSERSI0),

    // Input port SI1 signals
    .HSELSI1       (tie_hi),
    .HADDRSI1      (HADDRSI1),
    .HTRANSSI1     (HTRANSSI1),
    .HWRITESI1     (HWRITESI1),
    .HSIZESI1      (HSIZESI1),
    .HBURSTSI1     (HBURSTSI1),
    .HPROTSI1      (HPROTSI1),
    .HWDATASI1     (HWDATASI1),
    .HMASTLOCKSI1  (HMASTLOCKSI1),
    .HMASTERSI1    (tie_hi_4),
    .HREADYSI1     (HREADYSI1),
    .HAUSERSI1     (HAUSERSI1),
    .HWUSERSI1     (HWUSERSI1),
    .HRDATASI1     (HRDATASI1),
    .HREADYOUTSI1  (HREADYSI1),
    .HRESPSI1      (i_hrespSI1),
    .HRUSERSI1     (HRUSERSI1),

    // Input port SI2 signals
    .HSELSI2       (tie_hi),
    .HADDRSI2      (HADDRSI2),
    .HTRANSSI2     (HTRANSSI2),
    .HWRITESI2     (HWRITESI2),
    .HSIZESI2      (HSIZESI2),
    .HBURSTSI2     (HBURSTSI2),
    .HPROTSI2      (HPROTSI2),
    .HWDATASI2     (HWDATASI2),
    .HMASTLOCKSI2  (HMASTLOCKSI2),
    .HMASTERSI2    (tie_hi_4),
    .HREADYSI2     (HREADYSI2),
    .HAUSERSI2     (HAUSERSI2),
    .HWUSERSI2     (HWUSERSI2),
    .HRDATASI2     (HRDATASI2),
    .HREADYOUTSI2  (HREADYSI2),
    .HRESPSI2      (i_hrespSI2),
    .HRUSERSI2     (HRUSERSI2),


    // Output port MI0 signals
    .HSELMI0       (HSELMI0),
    .HADDRMI0      (HADDRMI0),
    .HTRANSMI0     (HTRANSMI0),
    .HWRITEMI0     (HWRITEMI0),
    .HSIZEMI0      (HSIZEMI0),
    .HBURSTMI0     (HBURSTMI0),
    .HPROTMI0      (HPROTMI0),
    .HWDATAMI0     (HWDATAMI0),
    .HMASTERMI0    (i_hmasterMI0),
    .HMASTLOCKMI0  (HMASTLOCKMI0),
    .HREADYMUXMI0  (HREADYMUXMI0),
    .HAUSERMI0     (HAUSERMI0),
    .HWUSERMI0     (HWUSERMI0),
    .HRDATAMI0     (HRDATAMI0),
    .HREADYOUTMI0  (HREADYOUTMI0),
    .HRESPMI0      (i_hrespMI0),
    .HRUSERMI0     (HRUSERMI0),

    // Output port MI1 signals
    .HSELMI1       (HSELMI1),
    .HADDRMI1      (HADDRMI1),
    .HTRANSMI1     (HTRANSMI1),
    .HWRITEMI1     (HWRITEMI1),
    .HSIZEMI1      (HSIZEMI1),
    .HBURSTMI1     (HBURSTMI1),
    .HPROTMI1      (HPROTMI1),
    .HWDATAMI1     (HWDATAMI1),
    .HMASTERMI1    (i_hmasterMI1),
    .HMASTLOCKMI1  (HMASTLOCKMI1),
    .HREADYMUXMI1  (HREADYMUXMI1),
    .HAUSERMI1     (HAUSERMI1),
    .HWUSERMI1     (HWUSERMI1),
    .HRDATAMI1     (HRDATAMI1),
    .HREADYOUTMI1  (HREADYOUTMI1),
    .HRESPMI1      (i_hrespMI1),
    .HRUSERMI1     (HRUSERMI1),

    // Output port MI2 signals
    .HSELMI2       (HSELMI2),
    .HADDRMI2      (HADDRMI2),
    .HTRANSMI2     (HTRANSMI2),
    .HWRITEMI2     (HWRITEMI2),
    .HSIZEMI2      (HSIZEMI2),
    .HBURSTMI2     (HBURSTMI2),
    .HPROTMI2      (HPROTMI2),
    .HWDATAMI2     (HWDATAMI2),
    .HMASTERMI2    (i_hmasterMI2),
    .HMASTLOCKMI2  (HMASTLOCKMI2),
    .HREADYMUXMI2  (HREADYMUXMI2),
    .HAUSERMI2     (HAUSERMI2),
    .HWUSERMI2     (HWUSERMI2),
    .HRDATAMI2     (HRDATAMI2),
    .HREADYOUTMI2  (HREADYOUTMI2),
    .HRESPMI2      (i_hrespMI2),
    .HRUSERMI2     (HRUSERMI2),


    // Scan test dummy signals; not connected until scan insertion
    .SCANENABLE            (SCANENABLE),
    .SCANINHCLK            (SCANINHCLK),
    .SCANOUTHCLK           (SCANOUTHCLK)
  );


endmodule

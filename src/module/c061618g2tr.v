/*
 * Copyright 2026 circuitli (https://github.com)
 *
 * Licensed under the CERN Open Hardware Licence Version 2 - Weakly Reciprocal (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://cern-ohl.web.cern.ch/
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// =========================================================================
// CONDITIONAL PDK INTERFACE RESOLUTION
// If compiling for physical synthesis (OpenLane/Yosys), hide the source file 
// so the tool treats the block as a clean hard macro blackbox.
// If compiling for local verification (Cocotb/Icarus), include the source
// so the simulator doesn't throw an 'Unknown module type' crash.
// =========================================================================

`ifndef C061618G2TR_V
`define C061618G2TR_V

`include "src/module/tt_output_voter.v"

`default_nettype none

module c061618g2tr (
    input  wire [7:0] ui_in,    // Dedicated hardware inputs
    output wire [7:0] uo_out,   // Dedicated hardware outputs
    input  wire [7:0] uio_in,   // Bidirectional bus input network
    (* keep = "yes" *) output wire [7:0] uio_out,  // Bidirectional bus output network
    (* keep = "yes" *) output wire [7:0] uio_oe,   // Safe output enablement bus mapping
    input  wire [0:0] ena,      // Tiny Tapeout macro block enable signal
    input  wire [0:0] clk,      // System clock injected for wrapper compliance
    input  wire [0:0] rst_n     // Active-low system reset
);

    wire [7:0] uo_out1, uo_out2, uo_out3;   // Dedicated hardware outputs
    wire [7:0] uio_out1, uio_out2, uio_out3;  // Bidirectional bus output network
    wire [7:0] uio_oe1, uio_oe2, uio_oe3;   // Safe output enablement bus mapping

    // =========================================================================
    // CORE HIERARCHICAL INSTANTIATION
    // =========================================================================
    (* dont_touch = "yes" *) 
    c061618g2 u_c061618g2_1 (
        .clk     (clk),
        .rst_n   (rst_n),
        .ui_in   (ui_in),
        .uo_out  (uo_out1),
        .uio_in  (uio_in),
        .uio_out (uio_out1),
        .uio_oe  (uio_oe1),
        .ena     (ena)
    );

    (* dont_touch = "yes" *) 
    c061618g2 u_c061618g2_2 (
        .clk     (clk),
        .rst_n   (rst_n),
        .ui_in   (ui_in),
        .uo_out  (uo_out2),
        .uio_in  (uio_in),
        .uio_out (uio_out2),
        .uio_oe  (uio_oe2),
        .ena     (ena)
    );

    (* dont_touch = "yes" *) 
    c061618g2 u_c061618g2_3 (
        .clk     (clk),
        .rst_n   (rst_n),
        .ui_in   (ui_in),
        .uo_out  (uo_out3),
        .uio_in  (uio_in),
        .uio_out (uio_out3),
        .uio_oe  (uio_oe3),
        .ena     (ena)
    );

    // =========================================================================
    // TRIPLE MODULAR REDUNDANCY (TMR) MAJORITY VOTING FILTERS
    // =========================================================================
    
    // 1. Declare protected intermediate nets to hold the voter equations
    (* dont_touch = "yes" *) wire [7:0] uo_out_voted;
    (* dont_touch = "yes" *) wire [7:0] uio_out_voted;
    (* dont_touch = "yes" *) wire [7:0] uio_oe_voted;

    // 2. Perform the logic equations onto the protected structures
    // Instantiate the voters using explicit port mapping and width parameters
    
    (* dont_touch = "yes" *)
    tt_output_voter #(.WIDTH(8)) u_tt_output_voter (
        // Redundant input groups
        .uo_out1       (uo_out1),
        .uo_out2       (uo_out2),
        .uo_out3       (uo_out3),
        
        .uio_out1      (uio_out1),
        .uio_out2      (uio_out2),
        .uio_out3      (uio_out3),
        
        .uio_oe1       (uio_oe1),
        .uio_oe2       (uio_oe2),
        .uio_oe3       (uio_oe3),

        // Hardened voted outputs
        .uo_out_voted  (uo_out_voted),
        .uio_out_voted (uio_out_voted),
        .uio_oe_voted  (uio_oe_voted)
    );

    // 3. Drive the top-level external hardware ports cleanly
    assign uo_out  = uo_out_voted;
    assign uio_out = uio_out_voted;
    assign uio_oe  = uio_oe_voted;

endmodule

module tt_um_c061618g2tr_bypass (input wire [7:0] ui_in, output wire [7:0] uo_out, input wire [7:0] uio_in, output wire [7:0] uio_out, output wire [7:0] uio_oe, input wire ena, clk, rst_n);
    (* dont_touch = "yes" *)
    c061618g2tr actual_design (
        .clk   (clk),
        .rst_n (rst_n),
        .ena   (ena),
        .*
    ); 
endmodule

`default_nettype wire
`endif

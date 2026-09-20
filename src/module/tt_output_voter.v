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

`ifndef TT_OUTPUT_VOTER_V
`define TT_OUTPUT_VOTER_V

`include "src/module/tmr_voter.v"

`default_nettype none

module tt_output_voter #(
    parameter WIDTH = 8  // Easily change the bus size for all signals at once
)(
    // Redundant input groups
    (* dont_touch = "yes" *) input  wire [WIDTH-1:0] uo_out1,   uo_out2,   uo_out3,
    (* dont_touch = "yes" *) input  wire [WIDTH-1:0] uio_out1,  uio_out2,  uio_out3,
    (* dont_touch = "yes" *) input  wire [WIDTH-1:0] uio_oe1,   uio_oe2,   uio_oe3,

    // Hardened voted outputs
    (* dont_touch = "yes" *) output wire [WIDTH-1:0] uo_out_voted,
    (* dont_touch = "yes" *) output wire [WIDTH-1:0] uio_out_voted,
    (* dont_touch = "yes" *) output wire [WIDTH-1:0] uio_oe_voted
);

    // 2. Perform the logic equations onto the protected structures
    // Instantiate the voters using explicit port mapping and width parameters
    
    (* dont_touch = "yes" *)
    tmr_voter #(.WIDTH(WIDTH)) u_uo_out_voter (
        .in1 (uo_out1),
        .in2 (uo_out2),
        .in3 (uo_out3),
        .out (uo_out_voted)
    );

    (* dont_touch = "yes" *)
    tmr_voter #(.WIDTH(WIDTH)) u_uio_out_voter (
        .in1 (uio_out1),
        .in2 (uio_out2),
        .in3 (uio_out3),
        .out (uio_out_voted)
    );

    (* dont_touch = "yes" *)
    tmr_voter #(.WIDTH(WIDTH)) u_uio_oe_voter (
        .in1 (uio_oe1),
        .in2 (uio_oe2),
        .in3 (uio_oe3),
        .out (uio_oe_voted)
    );

endmodule


`default_nettype wire
`endif

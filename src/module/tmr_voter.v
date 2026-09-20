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

`ifndef TMR_VOTER_V
`define TMR_VOTER_V

`default_nettype none

module tmr_voter #(
    parameter WIDTH = 8  // Default width is set to 8 bits
)(
    input  wire [WIDTH-1:0] in1,
    input  wire [WIDTH-1:0] in2,
    input  wire [WIDTH-1:0] in3,
    (* dont_touch = "yes", keep = "true" *) output wire [WIDTH-1:0] out
);

    // Majority voting logic applied bitwise across the entire vector width
    assign out = (in1 & in2) | 
                 (in2 & in3) | 
                 (in1 & in3);

endmodule

`default_nettype wire
`endif

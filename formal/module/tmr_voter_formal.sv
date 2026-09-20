/* Copyright 2026 circuitli (https://github.com)
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

`ifndef TMR_VOTER_FORMAL_SV
`define TMR_VOTER_FORMAL_SV

`include "src/module/tmr_voter.v"

`default_nettype none

module tmr_voter_formal #(
    parameter WIDTH = 8
)(
    input wire [WIDTH-1:0] in1,
    input wire [WIDTH-1:0] in2,
    input wire [WIDTH-1:0] in3,
    input wire [WIDTH-1:0] out
);

    // SymbiYosys processes combinational properties safely using immediate assertions 
    // inside a combinational evaluation block.
    always @(*) begin
        
        // Assert: If the majority math evaluates to a '1' for a bit, 'out' must match it.
        // We verify that (calculated_majority & ~out) evaluates to 0.
        assert ( (((in1 & in2) | (in2 & in3) | (in1 & in3)) & ~out) == 0 );

        // Assert: If the majority math evaluates to a '0' for a bit, 'out' must match it.
        // We verify that where the majority is low, 'out' is forced to 0.
        assert ( (((~in1 & ~in2) | (~in2 & ~in3) | (~in1 & ~in3)) & out) == 0 );

        // Cover statements for SBY cover mode
        cover( (((in1 & in2) | (in2 & in3) | (in1 & in3)) & out) != 0 );
        cover( (((~in1 & ~in2) | (~~in2 & ~in3) | (~in1 & ~in3)) & ~out) != 0 );
    end

endmodule

// Bind the formal module to the target design, forwarding the target's parameter
bind tmr_voter tmr_voter_formal #(
    .WIDTH(WIDTH) // Forwards the parameter value from the instantiated target module
) i_tmr_voter_formal (
    .in1(in1),
    .in2(in2),
    .in3(in3),
    .out(out)
);

`default_nettype wire
`endif 
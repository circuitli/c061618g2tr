`ifndef TT_OUTPUT_VOTER_FORMAL_SV
`define TT_OUTPUT_VOTER_FORMAL_SV

`include "src/module/tt_output_voter.v"

`include "formal/module/tmr_voter_formal.sv"

`default_nettype none

module tt_output_voter_formal #(
    parameter WIDTH = 8  // Dynamically scales to match your design width
)(
    input wire [WIDTH-1:0] uo_out1,   input wire [WIDTH-1:0] uo_out2,   input wire [WIDTH-1:0] uo_out3,
    input wire [WIDTH-1:0] uio_out1,  input wire [WIDTH-1:0] uio_out2,  input wire [WIDTH-1:0] uio_out3,
    input wire [WIDTH-1:0] uio_oe1,   input wire [WIDTH-1:0] uio_oe2,   input wire [WIDTH-1:0] uio_oe3,

    input wire [WIDTH-1:0] uo_out_voted,
    input wire [WIDTH-1:0] uio_out_voted,
    input wire [WIDTH-1:0] uio_oe_voted
);

    // SymbiYosys requires immediate assertions inside procedural combinational blocks
    always_comb begin
        
        // ==========================================
        // 1. Assertions for uo_out_voted
        // ==========================================
        // If calculated majority math is 1, output bit must be 1 (No false lows)
        assert ((((uo_out1 & uo_out2) | (uo_out2 & uo_out3) | (uo_out1 & uo_out3)) & ~uo_out_voted) == 0);
        // If calculated majority math is 0, output bit must be 0 (No false highs)
        assert ((((~uo_out1 & ~uo_out2) | (~uo_out2 & ~uo_out3) | (~uo_out1 & ~uo_out3)) & uo_out_voted) == 0);

        // ==========================================
        // 2. Assertions for uio_out_voted
        // ==========================================
        assert ((((uio_out1 & uio_out2) | (uio_out2 & uio_out3) | (uio_out1 & uio_out3)) & ~uio_out_voted) == 0);
        assert ((((~uio_out1 & ~uio_out2) | (~uio_out2 & ~uio_out3) | (~uio_out1 & ~uio_out3)) & uio_out_voted) == 0);

        // ==========================================
        // 3. Assertions for uio_oe_voted
        // ==========================================
        assert ((((uio_oe1 & uio_oe2) | (uio_oe2 & uio_oe3) | (uio_oe1 & uio_oe3)) & ~uio_oe_voted) == 0);
        assert ((((~uio_oe1 & ~uio_oe2) | (~uio_oe2 & ~uio_oe3) | (~uio_oe1 & ~uio_oe3)) & uio_oe_voted) == 0);

        // ==========================================
        // 4. Cover States (For SBY cover mode checking)
        // ==========================================
        cover (uo_out_voted  != 0);
        cover (uio_out_voted != 0);
        cover (uio_oe_voted  != 0);
    end

endmodule

// SBY-compatible bind module mapping
bind tt_output_voter tt_output_voter_formal #(
    .WIDTH(WIDTH) // Forwards parameter to match the parent module dynamically
) i_tt_output_voter_formal (
    .uo_out1(uo_out1),   .uo_out2(uo_out2),   .uo_out3(uo_out3),
    .uio_out1(uio_out1), .uio_out2(uio_out2), .uio_out3(uio_out3),
    .uio_oe1(uio_oe1),   .uio_oe2(uio_oe2),   .uio_oe3(uio_oe3),
    .uo_out_voted(uo_out_voted),
    .uio_out_voted(uio_out_voted),
    .uio_oe_voted(uio_oe_voted)
);

`default_nettype wire
`endif

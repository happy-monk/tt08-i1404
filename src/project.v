/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_i1404 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  parameter DEPTH = 1024;

  reg [DEPTH-1:0] shift_reg;
  wire din, clken, dout;
  assign din = uio_in[0];
  assign clken = ui_in[0];
  assign dout = shift_reg[DEPTH-1];

  always @(posedge clk) begin
    if (clken) begin
      shift_reg[DEPTH-1:1] <= shift_reg[DEPTH-2:0];
      shift_reg[0] <= din;
    end
  end;


  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = dout;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
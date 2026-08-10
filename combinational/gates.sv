//-----------------------------------------------------------------------------
//
// Experiments with simple logical gates
//
//-----------------------------------------------------------------------------

// Harris and Harris examples 4.2 and 4.3
module gates(input logic [3:0] a, b,
             output logic [3:0] yinv, yand, yor, yxor, ynand, ynor);
  assign yinv = ~a;
  assign yand = a & b;
  assign yor = a | b;
  assign yxor = a ^ b;
  assign ynand = ~(a & b);
  assign ynor = ~(a | b);
endmodule

// Harris and Harris example 4.4
module and8(input logic[7:0] a,
            output logic y);
  assign y = &a;
endmodule

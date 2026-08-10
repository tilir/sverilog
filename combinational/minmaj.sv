// Harris and Harris excercise 4.5
module minority (input logic a, b, c,
                 output logic y);
  assign y = (~a & ~b) | (~b & ~c) | (~a & ~c);
endmodule;

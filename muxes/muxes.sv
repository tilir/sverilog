//-----------------------------------------------------------------------------
//
// Experiments with multiplexors, behavioral and structural design
//
//-----------------------------------------------------------------------------

// Harris and Harris example 4.5
module mux2(input logic[3:0] d0, d1,
            input logic s,
            output logic[3:0] y);
  assign y = s ? d1 : d0;
endmodule;

// Harris and Harris example 4.6
// behavioral approach
module mux4(input logic[3:0] d0, d1, d2, d3,
            input logic[1:0] s,
            output logic[3:0] y);
  assign y = s[1] ? (s[0] ? d3 : d2) : (s[0] ? d1 : d0);
endmodule;

// Harris and Harris example 4.10
module tristate(input logic[3:0] a,
                input logic en,
                output wire[3:0] y);
  assign y = en ? a : 4'bz;
endmodule;

// Harris and Harris example 4.14
// structural approach
module mux4structural(input logic[3:0] d0, d1, d2, d3,
                      input logic[1:0] s,
                       output logic[3:0] y);
  logic[3:0] low, high;
  mux2 lowmux(d0, d1, s[0], low);
  mux2 highmux(d2, d3, s[0], high);
  mux2 finalmux(low, high, s[1], y);
endmodule;

// Harris and Harris example 4.15
module mux2tristate(input logic[3:0] d0, d1,
                    input logic s,
                    output wire[3:0] y);
  tristate t0(d0, ~s, y);
  tristate t1(d1, s, y);
endmodule;

// even more structural approach
module mux4tristate(input logic[3:0] d0, d1, d2, d3,
                    input logic[1:0] s,
                    output wire[3:0] y);
  wire[3:0] low, high;
  mux2tristate lowmux(d0, d1, s[0], low);
  mux2tristate highmux(d2, d3, s[0], high);
  mux2tristate finalmux(low, high, s[1], y);
endmodule;

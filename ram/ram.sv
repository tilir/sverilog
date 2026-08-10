// Simple synchronous RAM used to experiment with interfaces and modports.

interface DataBus;
  logic [7:0] Addr;
  logic [7:0] WriteData;
  logic [7:0] ReadData;

  modport Test (output Addr, WriteData, input ReadData);
  modport Ram  (input Addr, WriteData, output ReadData);
endinterface

interface CtrlBus;
  logic WriteEnable;

  modport Test (output WriteEnable);
  modport Ram  (input WriteEnable);
endinterface

module ram(input logic Clk, DataBus.Ram DataInt, CtrlBus.Ram CtrlInt);
  timeunit 1ns;
  timeprecision 1ps;

  logic [7:0] mem [0:255];

  always_ff @(posedge Clk) begin
    if (CtrlInt.WriteEnable)
      mem[DataInt.Addr] <= DataInt.WriteData;
    else
      DataInt.ReadData <= mem[DataInt.Addr];
  end
endmodule

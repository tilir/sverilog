module counter_testbench;
  import tb_util_pkg::*;
  logic clock, reset, enable, load, up;
  logic [7:0] data;
  wire [7:0] q;

  counter dut(clock, reset, enable, load, up, data, q);
  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  task automatic tick_and_check(input logic [7:0] expected,
                                input string operation);
    @(posedge clock);
    #1;
    check("counter.Q", q, expected, 8, operation);
  endtask

  initial begin
    init_tests();
    reset = 1; enable = 0; load = 0; up = 1; data = 0;
    #1;
    check("counter.Q", q, 0, 8, "asynchronous reset");
    reset = 0;

    begin_test("control operations");
    tick_and_check(0, "disabled counter holds");
    enable = 1; load = 1; data = 8'h42;
    tick_and_check(8'h42, "parallel load");
    load = 0; up = 1;
    tick_and_check(8'h43, "count up");
    tick_and_check(8'h44, "count up again");
    up = 0;
    tick_and_check(8'h43, "count down");
    enable = 0;
    tick_and_check(8'h43, "disabled counter holds loaded state");
    end_test("control operations");

    begin_test("wraparound");
    enable = 1; load = 1; data = 8'hff;
    tick_and_check(8'hff, "load maximum");
    load = 0; up = 1;
    tick_and_check(8'h00, "wrap upward");
    up = 0;
    tick_and_check(8'hff, "wrap downward");
    end_test("wraparound");
    finish_tests("counter");
  end
endmodule

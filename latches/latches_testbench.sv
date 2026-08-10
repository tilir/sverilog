// Self-checking tests for the two SR latch implementations.
// Runtime options: +verbose, +trace.

module latches_testbench;
  import tb_util_pkg::*;

  logic s, r;
  wire naive_q, naive_q_not;
  wire rtl_q, rtl_q_not;

  sr_latch_naive naive_dut(s, r, naive_q, naive_q_not);
  sr_latch rtl_dut(s, r, rtl_q, rtl_q_not);

  task automatic apply_and_check(input logic next_s,
                                 input logic next_r,
                                 input logic expected_q,
                                 input logic expected_q_not,
                                 input string operation);
    s = next_s;
    r = next_r;
    // The gate-level model has #1 feedback delays; allow it to settle.
    #5;
    check("naive.Q", naive_q, expected_q, 1, operation);
    check("naive.Q_not", naive_q_not, expected_q_not, 1, operation);
    check("rtl.Q", rtl_q, expected_q, 1, operation);
    check("rtl.Q_not", rtl_q_not, expected_q_not, 1, operation);
  endtask

  task automatic test_reset_and_hold;
    begin_test("reset and hold 0");
    apply_and_check(0, 1, 0, 1, "reset S=0 R=1");
    apply_and_check(0, 0, 0, 1, "hold reset value S=0 R=0");
    end_test("reset and hold 0");
  endtask

  task automatic test_set_and_hold;
    begin_test("set and hold 1");
    apply_and_check(1, 0, 1, 0, "set S=1 R=0");
    apply_and_check(0, 0, 1, 0, "hold set value S=0 R=0");
    end_test("set and hold 1");
  endtask

  task automatic test_forbidden_and_recovery;
    begin_test("forbidden and recovery");
    apply_and_check(1, 1, 0, 0, "forbidden S=1 R=1");

    // Do not release directly to S=R=0: a physical SR latch may resolve to
    // either state. Drive it to a known state first, then test normal use.
    apply_and_check(0, 1, 0, 1, "recover with reset");
    apply_and_check(1, 0, 1, 0, "recover with set");
    apply_and_check(0, 0, 1, 0, "hold after recovery");
    end_test("forbidden and recovery");
  endtask

  initial begin
    init_tests();
    if ($test$plusargs("trace")) begin
      $dumpfile("latches.fst");
      $dumpvars(0, latches_testbench);
    end

    // Establish a known state before observing either feedback loop.
    s = 0;
    r = 1;
    #5;

    test_reset_and_hold();
    test_set_and_hold();
    test_forbidden_and_recovery();
    finish_tests("latches");
  end
endmodule

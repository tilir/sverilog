// Self-checking testbench for the combinational logic examples.
// Runtime options: +verbose, +trace, +iterations=N, +seed=N.

module comb_testbench;
  int unsigned checks;
  int unsigned failures;
  int unsigned test_checks;
  int unsigned test_failures;
  int unsigned random_iterations = 100;
  int unsigned random_seed;
  bit verbose;

  logic       sf_a, sf_b, sf_c, sf_y;
  logic [3:0] gates_a, gates_b;
  logic [3:0] gates_inv, gates_and, gates_or, gates_xor;
  logic [3:0] gates_nand, gates_nor;
  logic [7:0] and8_a;
  logic       and8_y;
  logic [3:0] xor4_a;
  logic       xor4_y;
  logic       min_a, min_b, min_c, min_y;
  logic [3:0] mux_d0, mux_d1, mux_d2, mux_d3;
  logic       mux_s;
  logic [1:0] mux_s4;
  logic [3:0] mux2_y, mux4_y, mux4s_y, mux2s_y, mux4ss_y;
  logic [3:0] seven_data;
  logic [6:0] seven_seg;

  sillyfunction sf_dut(sf_a, sf_b, sf_c, sf_y);
  gates gates_dut(gates_a, gates_b, gates_inv, gates_and, gates_or,
                  gates_xor, gates_nand, gates_nor);
  and8 and8_dut(and8_a, and8_y);
  xorfour xor4_dut(xor4_a, xor4_y);
  minority minority_dut(min_a, min_b, min_c, min_y);
  mux2 mux2_dut(mux_d0, mux_d1, mux_s, mux2_y);
  mux4 mux4_dut(mux_d0, mux_d1, mux_d2, mux_d3, mux_s4, mux4_y);
  mux4s mux4s_dut(mux_d0, mux_d1, mux_d2, mux_d3, mux_s4, mux4s_y);
  mux2s mux2s_dut(mux_d0, mux_d1, mux_s, mux2s_y);
  mux4ss mux4ss_dut(mux_d0, mux_d1, mux_d2, mux_d3, mux_s4, mux4ss_y);
  sevensegment sevensegment_dut(seven_data, seven_seg);

  task automatic begin_test(input string name);
    test_checks = checks;
    test_failures = failures;
    $display("RUN  %s", name);
  endtask

  task automatic end_test(input string name);
    if (failures == test_failures)
      $display("PASS %-18s %0d checks", name, checks - test_checks);
    else
      $display("FAIL %-18s %0d of %0d checks", name,
               failures - test_failures, checks - test_checks);
  endtask

  task automatic check(input string name,
                       input logic [31:0] actual,
                       input logic [31:0] expected,
                       input int unsigned width,
                       input string details);
    logic [31:0] mask;
    mask = width == 32 ? '1 : (32'(1) << width) - 1;
    checks++;
    if ((actual & mask) !== (expected & mask)) begin
      failures++;
      $display("  FAIL %s: %s, actual=%0h expected=%0h",
               name, details, actual & mask, expected & mask);
    end else if (verbose) begin
      $display("  ok   %s: %s, result=%0h", name, details, actual & mask);
    end
  endtask

  function automatic logic [6:0] expected_segments(input logic [3:0] data);
    case (data)
      4'h0: expected_segments = 7'b1_11_1_11_0;
      4'h1: expected_segments = 7'b0_11_0_00_0;
      4'h2: expected_segments = 7'b1_10_1_10_1;
      4'h3: expected_segments = 7'b1_11_1_00_1;
      4'h4: expected_segments = 7'b0_11_0_01_1;
      4'h5: expected_segments = 7'b1_01_1_01_1;
      4'h6: expected_segments = 7'b1_01_1_11_1;
      4'h7: expected_segments = 7'b1_11_0_00_0;
      4'h8: expected_segments = 7'b1_11_1_11_1;
      4'h9: expected_segments = 7'b1_11_1_01_1;
      4'hA: expected_segments = 7'b1_11_0_11_1;
      4'hB: expected_segments = 7'b0_01_1_11_1;
      4'hC: expected_segments = 7'b1_00_1_11_0;
      4'hD: expected_segments = 7'b0_11_1_10_1;
      4'hE: expected_segments = 7'b1_00_1_11_1;
      4'hF: expected_segments = 7'b1_00_0_11_1;
    endcase
  endfunction

  task automatic test_sillyfunction;
    begin_test("sillyfunction");
    for (int value = 0; value < 8; value++) begin
      {sf_a, sf_b, sf_c} = 3'(value);
      #1;
      check("sillyfunction.y", sf_y,
            (~sf_a & ~sf_b & ~sf_c) | (sf_a & ~sf_b), 1,
            $sformatf("a=%0b b=%0b c=%0b", sf_a, sf_b, sf_c));
    end
    end_test("sillyfunction");
  endtask

  task automatic test_gates;
    begin_test("gates");
    for (int a = 0; a < 16; a++) begin
      for (int b = 0; b < 16; b++) begin
        gates_a = 4'(a);
        gates_b = 4'(b);
        #1;
        check("gates.yinv",  gates_inv,  ~gates_a,             4, $sformatf("a=%h", gates_a));
        check("gates.yand",  gates_and,   gates_a & gates_b,   4, $sformatf("a=%h b=%h", gates_a, gates_b));
        check("gates.yor",   gates_or,    gates_a | gates_b,   4, $sformatf("a=%h b=%h", gates_a, gates_b));
        check("gates.yxor",  gates_xor,   gates_a ^ gates_b,   4, $sformatf("a=%h b=%h", gates_a, gates_b));
        check("gates.ynand", gates_nand, ~(gates_a & gates_b), 4, $sformatf("a=%h b=%h", gates_a, gates_b));
        check("gates.ynor",  gates_nor,  ~(gates_a | gates_b), 4, $sformatf("a=%h b=%h", gates_a, gates_b));
      end
    end
    end_test("gates");
  endtask

  task automatic test_and8;
    begin_test("and8");
    for (int value = 0; value < 256; value++) begin
      and8_a = 8'(value);
      #1;
      check("and8.y", and8_y, &and8_a, 1, $sformatf("a=%h", and8_a));
    end
    end_test("and8");
  endtask

  task automatic test_xorfour;
    begin_test("xorfour");
    for (int value = 0; value < 16; value++) begin
      xor4_a = 4'(value);
      #1;
      check("xorfour.y", xor4_y, ^xor4_a, 1, $sformatf("a=%h", xor4_a));
    end
    end_test("xorfour");
  endtask

  task automatic test_minority;
    begin_test("minority");
    for (int value = 0; value < 8; value++) begin
      {min_a, min_b, min_c} = 3'(value);
      #1;
      check("minority.y", min_y, ($countones({min_a, min_b, min_c}) < 2), 1,
            $sformatf("a=%0b b=%0b c=%0b", min_a, min_b, min_c));
    end
    end_test("minority");
  endtask

  task automatic check_mux_vector(input logic [3:0] d0, d1, d2, d3);
    mux_d0 = d0;
    mux_d1 = d1;
    mux_d2 = d2;
    mux_d3 = d3;
    for (int select = 0; select < 4; select++) begin
      mux_s = select[0];
      mux_s4 = 2'(select);
      #1;
      check("mux2.y", mux2_y, mux_s ? mux_d1 : mux_d0, 4,
            $sformatf("s=%0b d0=%h d1=%h", mux_s, mux_d0, mux_d1));
      check("mux2s.y", mux2s_y, mux_s ? mux_d1 : mux_d0, 4,
            $sformatf("s=%0b d0=%h d1=%h", mux_s, mux_d0, mux_d1));
      case (mux_s4)
        0: begin
          check("mux4.y", mux4_y, mux_d0, 4, $sformatf("s=%0d", mux_s4));
          check("mux4s.y", mux4s_y, mux_d0, 4, $sformatf("s=%0d", mux_s4));
          check("mux4ss.y", mux4ss_y, mux_d0, 4, $sformatf("s=%0d", mux_s4));
        end
        1: begin
          check("mux4.y", mux4_y, mux_d1, 4, $sformatf("s=%0d", mux_s4));
          check("mux4s.y", mux4s_y, mux_d1, 4, $sformatf("s=%0d", mux_s4));
          check("mux4ss.y", mux4ss_y, mux_d1, 4, $sformatf("s=%0d", mux_s4));
        end
        2: begin
          check("mux4.y", mux4_y, mux_d2, 4, $sformatf("s=%0d", mux_s4));
          check("mux4s.y", mux4s_y, mux_d2, 4, $sformatf("s=%0d", mux_s4));
          check("mux4ss.y", mux4ss_y, mux_d2, 4, $sformatf("s=%0d", mux_s4));
        end
        3: begin
          check("mux4.y", mux4_y, mux_d3, 4, $sformatf("s=%0d", mux_s4));
          check("mux4s.y", mux4s_y, mux_d3, 4, $sformatf("s=%0d", mux_s4));
          check("mux4ss.y", mux4ss_y, mux_d3, 4, $sformatf("s=%0d", mux_s4));
        end
      endcase
    end
  endtask

  task automatic test_muxes;
    begin_test("muxes");
    $display("INFO mux random iterations=%0d seed=%0d",
             random_iterations, random_seed);
    check_mux_vector(4'h0, 4'hf, 4'h5, 4'ha);
    check_mux_vector(4'h1, 4'h2, 4'h4, 4'h8);
    for (int iteration = 0; iteration < random_iterations; iteration++)
      check_mux_vector(4'($urandom), 4'($urandom), 4'($urandom), 4'($urandom));
    end_test("muxes");
  endtask

  task automatic test_sevensegment;
    begin_test("sevensegment");
    for (int value = 0; value < 16; value++) begin
      seven_data = 4'(value);
      #1;
      check("sevensegment.seg", seven_seg, expected_segments(seven_data), 7,
            $sformatf("data=%h", seven_data));
    end
    end_test("sevensegment");
  endtask

  initial begin
    verbose = $test$plusargs("verbose");
    if (!$value$plusargs("iterations=%d", random_iterations))
      random_iterations = 100;
    if (!$value$plusargs("seed=%d", random_seed))
      random_seed = 1;
    void'($urandom(random_seed));
    if ($test$plusargs("trace")) begin
      $dumpfile("combinational.fst");
      $dumpvars(0, comb_testbench);
    end

    test_sillyfunction();
    test_gates();
    test_and8();
    test_xorfour();
    test_minority();
    test_muxes();
    test_sevensegment();

    $display("--------------------------------------------------");
    if (failures == 0) begin
      $display("PASS: %0d checks, no failures", checks);
      $finish;
    end else begin
      $display("FAIL: %0d checks, %0d failures", checks, failures);
      $fatal(1, "combinational tests failed");
    end
  end
endmodule

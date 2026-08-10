// Self-checking testbench for the combinational logic examples.
// Runtime options: +verbose, +trace.

module comb_testbench;
  import tb_util_pkg::*;

  logic       sf_a, sf_b, sf_c, sf_y;
  logic [3:0] gates_a, gates_b;
  logic [3:0] gates_inv, gates_and, gates_or, gates_xor;
  logic [3:0] gates_nand, gates_nor;
  logic [7:0] and8_a;
  logic       and8_y;
  logic [3:0] xor4_a;
  logic       xor4_y;
  logic       min_a, min_b, min_c, min_y;
  logic [3:0] seven_data;
  logic [6:0] seven_seg;

  sillyfunction sf_dut(sf_a, sf_b, sf_c, sf_y);
  gates gates_dut(gates_a, gates_b, gates_inv, gates_and, gates_or,
                  gates_xor, gates_nand, gates_nor);
  and8 and8_dut(and8_a, and8_y);
  xorfour xor4_dut(xor4_a, xor4_y);
  minority minority_dut(min_a, min_b, min_c, min_y);
  sevensegment sevensegment_dut(seven_data, seven_seg);

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
      check("minority.y", min_y,
            1'(({1'b0, min_a} + {1'b0, min_b} + {1'b0, min_c}) < 2'd2), 1,
            $sformatf("a=%0b b=%0b c=%0b", min_a, min_b, min_c));
    end
    end_test("minority");
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
    init_tests();
    if ($test$plusargs("trace")) begin
      $dumpfile("combinational.fst");
      $dumpvars(0, comb_testbench);
    end

    test_sillyfunction();
    test_gates();
    test_and8();
    test_xorfour();
    test_minority();
    test_sevensegment();
    finish_tests("combinational");
  end
endmodule

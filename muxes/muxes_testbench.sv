// Self-checking comparison of behavioral and structural multiplexors.
// Runtime options: +verbose, +trace.

module muxes_testbench;
  import tb_util_pkg::*;

  logic [3:0] d0, d1, d2, d3;
  logic       s2;
  logic [1:0] s4;
  logic [3:0] mux2_y;
  wire  [3:0] mux2tristate_y;
  logic [3:0] mux4_y, mux4structural_y;
  wire  [3:0] mux4tristate_y;

  mux2 mux2_dut(d0, d1, s2, mux2_y);
  mux2tristate mux2tristate_dut(d0, d1, s2, mux2tristate_y);
  mux4 mux4_dut(d0, d1, d2, d3, s4, mux4_y);
  mux4structural mux4structural_dut(
    d0, d1, d2, d3, s4, mux4structural_y);
  mux4tristate mux4tristate_dut(
    d0, d1, d2, d3, s4, mux4tristate_y);

  function automatic logic [3:0] mux4_reference;
    case (s4)
      2'd0: mux4_reference = d0;
      2'd1: mux4_reference = d1;
      2'd2: mux4_reference = d2;
      2'd3: mux4_reference = d3;
    endcase
  endfunction

  task automatic test_mux2;
    logic [3:0] expected;
    begin_test("mux2 implementations");
    for (int first = 0; first < 16; first++) begin
      for (int second = 0; second < 16; second++) begin
        for (int select = 0; select < 2; select++) begin
          d0 = 4'(first);
          d1 = 4'(second);
          s2 = select[0];
          #1;
          expected = s2 ? d1 : d0;
          check("mux2", mux2_y, expected, 4,
                $sformatf("s=%0b d0=%h d1=%h", s2, d0, d1));
          check("mux2tristate", mux2tristate_y, expected, 4,
                $sformatf("s=%0b d0=%h d1=%h", s2, d0, d1));
        end
      end
    end
    end_test("mux2 implementations");
  endtask

  task automatic test_mux4;
    logic [3:0] expected;
    begin_test("mux4 implementations");
    for (int first = 0; first < 16; first++) begin
      for (int second = 0; second < 16; second++) begin
        for (int third = 0; third < 16; third++) begin
          for (int fourth = 0; fourth < 16; fourth++) begin
            for (int select = 0; select < 4; select++) begin
              d0 = 4'(first);
              d1 = 4'(second);
              d2 = 4'(third);
              d3 = 4'(fourth);
              s4 = 2'(select);
              #1;
              expected = mux4_reference();
              check("mux4", mux4_y, expected, 4,
                    $sformatf("s=%0d d=%h,%h,%h,%h", s4, d0, d1, d2, d3));
              check("mux4structural", mux4structural_y, expected, 4,
                    $sformatf("s=%0d d=%h,%h,%h,%h", s4, d0, d1, d2, d3));
              check("mux4tristate", mux4tristate_y, expected, 4,
                    $sformatf("s=%0d d=%h,%h,%h,%h", s4, d0, d1, d2, d3));
            end
          end
        end
      end
    end
    end_test("mux4 implementations");
  endtask

  initial begin
    init_tests();
    if ($test$plusargs("trace")) begin
      $dumpfile("muxes.fst");
      $dumpvars(0, muxes_testbench);
    end

    test_mux2();
    test_mux4();
    finish_tests("muxes");
  end
endmodule

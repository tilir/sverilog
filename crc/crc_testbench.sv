// Self-checking testbench for CRC-16/XMODEM.
// Runtime options: +verbose, +trace.

module crc_testbench;
  timeunit 1ns;
  timeprecision 1ps;
  import tb_util_pkg::*;

  logic        clock;
  logic        rst_n;
  logic        clear;
  logic        enable;
  logic [7:0]  data_in;
  logic [15:0] crc_out;
  logic [15:0] expected_crc;

  crc16_8bit dut(clock, rst_n, clear, enable, data_in, crc_out);

  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  function automatic logic [15:0] crc16_byte_ref(
    input logic [15:0] crc,
    input logic [7:0] data
  );
    logic [15:0] c;
    logic feedback;

    c = crc;
    for (int i = 7; i >= 0; --i) begin
      feedback = c[15] ^ data[i];
      c = c << 1;
      if (feedback)
        c = c ^ 16'h1021;
    end
    return c;
  endfunction

  function automatic logic [7:0] check_byte(input int index);
    case (index)
      0: return "1";
      1: return "2";
      2: return "3";
      3: return "4";
      4: return "5";
      5: return "6";
      6: return "7";
      7: return "8";
      8: return "9";
      default: return 8'h00;
    endcase
  endfunction

  task automatic check_crc(input string operation);
    check("crc.out", crc_out, expected_crc, 16,
          $sformatf("%s data=%02h", operation, data_in));
  endtask

  task automatic reset_dut;
    @(negedge clock);
    rst_n = 0;
    clear = 0;
    enable = 0;
    data_in = 0;
    @(posedge clock);
    #1;
    expected_crc = 16'h0000;
    @(negedge clock);
    rst_n = 1;
  endtask

  task automatic clear_crc;
    @(negedge clock);
    clear = 1;
    enable = 0;
    @(posedge clock);
    #1;
    expected_crc = 16'h0000;
    check_crc("clear");
    @(negedge clock);
    clear = 0;
  endtask

  task automatic consume_and_check(input logic [7:0] data,
                                   input string operation);
    @(negedge clock);
    data_in = data;
    enable = 1;
    expected_crc = crc16_byte_ref(expected_crc, data);
    @(posedge clock);
    #1;
    check_crc(operation);
    @(negedge clock);
    enable = 0;
  endtask

  task automatic test_control_inputs;
    begin_test("reset, hold, and clear");
    reset_dut();
    check_crc("reset");

    consume_and_check(8'hA5, "initial byte");

    @(negedge clock);
    data_in = 8'h5A;
    enable = 0;
    @(posedge clock);
    #1;
    check_crc("enable=0 holds state");

    @(negedge clock);
    clear = 1;
    enable = 1;
    data_in = 8'hFF;
    @(posedge clock);
    #1;
    expected_crc = 16'h0000;
    check_crc("clear has priority over enable");

    @(negedge clock);
    rst_n = 0;
    clear = 0;
    enable = 1;
    data_in = 8'hFF;
    @(posedge clock);
    #1;
    check_crc("reset has priority over enable");

    @(negedge clock);
    rst_n = 1;
    enable = 0;
    end_test("reset, hold, and clear");
  endtask

  task automatic test_each_byte;
    begin_test("each byte from zero");
    for (int data = 0; data < 256; ++data) begin
      clear_crc();
      consume_and_check(8'(data), "single byte");
    end
    end_test("each byte from zero");
  endtask

  task automatic test_byte_sequence;
    begin_test("accumulating byte sequence");
    clear_crc();
    for (int data = 0; data < 256; ++data)
      consume_and_check(8'(data), "sequence byte");
    end_test("accumulating byte sequence");
  endtask

  task automatic test_known_vector;
    begin_test("123456789 check vector");
    clear_crc();
    for (int index = 0; index < 9; ++index)
      consume_and_check(check_byte(index), "check vector byte");
    check("crc.check", crc_out, 16'h31C3, 16,
          "CRC-16/XMODEM check value for 123456789");
    end_test("123456789 check vector");
  endtask

  initial begin
    rst_n = 1;
    clear = 0;
    enable = 0;
    data_in = 0;
    expected_crc = 0;
    init_tests();

    if ($test$plusargs("trace")) begin
      $dumpfile("crc.fst");
      $dumpvars(0, crc_testbench);
    end

    test_control_inputs();
    test_each_byte();
    test_byte_sequence();
    test_known_vector();
    finish_tests("crc");
  end
endmodule

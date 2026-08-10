// Self-checking testbench for the interface-based synchronous RAM.
// Runtime options: +verbose, +trace.

module ram_testbench;
  import tb_util_pkg::*;
  timeunit 1ns;
  timeprecision 1ps;

  logic clock;
  DataBus data_bus();
  CtrlBus ctrl_bus();

  ram dut(.Clk(clock), .DataInt(data_bus.Ram), .CtrlInt(ctrl_bus.Ram));

  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  task automatic write_byte(input logic [7:0] address,
                            input logic [7:0] value);
    data_bus.Addr = address;
    data_bus.WriteData = value;
    ctrl_bus.WriteEnable = 1;
    @(posedge clock);
    #1;
  endtask

  task automatic read_and_check(input logic [7:0] address,
                                input logic [7:0] expected,
                                input string operation);
    data_bus.Addr = address;
    ctrl_bus.WriteEnable = 0;
    @(posedge clock);
    #1;
    check("ram.ReadData", data_bus.ReadData, expected, 8,
          $sformatf("%s address=%02h", operation, address));
  endtask

  function automatic logic [7:0] pattern(input logic [7:0] address);
    // Both address halves influence the result, which catches common
    // addressing and truncation mistakes better than pattern=address.
    pattern = {address[3:0] ^ 4'ha, address[7:4] ^ 4'h5};
  endfunction

  task automatic test_basic_access;
    begin_test("basic access");
    write_byte(8'h12, 8'ha5);
    read_and_check(8'h12, 8'ha5, "read after write");
    end_test("basic access");
  endtask

  task automatic test_address_isolation;
    begin_test("address isolation");
    write_byte(8'h00, 8'h11);
    write_byte(8'h01, 8'h22);
    write_byte(8'h80, 8'h33);
    write_byte(8'hff, 8'h44);
    read_and_check(8'h00, 8'h11, "isolated value");
    read_and_check(8'h01, 8'h22, "isolated value");
    read_and_check(8'h80, 8'h33, "isolated value");
    read_and_check(8'hff, 8'h44, "isolated value");
    end_test("address isolation");
  endtask

  task automatic test_overwrite;
    begin_test("overwrite");
    write_byte(8'h42, 8'h0f);
    write_byte(8'h42, 8'hf0);
    read_and_check(8'h42, 8'hf0, "latest write wins");
    end_test("overwrite");
  endtask

  task automatic test_synchronous_read;
    begin_test("synchronous read");
    write_byte(8'h20, 8'hca);
    write_byte(8'h21, 8'hfe);
    read_and_check(8'h20, 8'hca, "establish read data");

    // Merely changing the address must not change a synchronous read port.
    data_bus.Addr = 8'h21;
    #2;
    check("ram.ReadData", data_bus.ReadData, 8'hca, 8,
          "address changed before clock");
    @(posedge clock);
    #1;
    check("ram.ReadData", data_bus.ReadData, 8'hfe, 8,
          "new address sampled on clock");
    end_test("synchronous read");
  endtask

  task automatic test_full_memory;
    begin_test("full memory sweep");
    for (int address = 0; address < 256; address++)
      write_byte(8'(address), pattern(8'(address)));
    for (int address = 0; address < 256; address++)
      read_and_check(8'(address), pattern(8'(address)), "memory sweep");
    end_test("full memory sweep");
  endtask

  initial begin
    init_tests();
    data_bus.Addr = 0;
    data_bus.WriteData = 0;
    ctrl_bus.WriteEnable = 0;

    if ($test$plusargs("trace")) begin
      $dumpfile("ram.fst");
      $dumpvars(0, ram_testbench);
    end

    test_basic_access();
    test_address_isolation();
    test_overwrite();
    test_synchronous_read();
    test_full_memory();
    finish_tests("ram");
  end
endmodule

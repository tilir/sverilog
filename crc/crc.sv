module crc16_8bit_equations (
    input  logic        clk,
    input  logic        rst_n,

    // Start a new CRC calculation.
    // Gives CRC state 16'h0000.
    input  logic        clear,

    // Consume data_in[7:0] this cycle.
    input  logic        enable,
    input  logic [7:0]  data_in,

    output logic [15:0] crc_out
);

  logic [15:0] crc_reg;
  logic [15:0] crc_next;

  //
  // CRC-16:
  //
  //   G(x) = x^16 + x^12 + x^5 + 1
  //
  // polynomial: 16'h1021
  //
  // Input byte is processed MSB first:
  //   data_in[7], data_in[6], ..., data_in[0]
  //
  // crc_next is the result of eight serial CRC steps,
  // algebraically collapsed into a combinational XOR network.
  //

  always_comb begin
    crc_next[15] =
        crc_reg[7]  ^
        crc_reg[11] ^
        crc_reg[15] ^
        data_in[3]  ^
        data_in[7];

    crc_next[14] =
        crc_reg[6]  ^
        crc_reg[10] ^
        crc_reg[14] ^
        data_in[2]  ^
        data_in[6];

    crc_next[13] =
        crc_reg[5]  ^
        crc_reg[9]  ^
        crc_reg[13] ^
        data_in[1]  ^
        data_in[5];

    crc_next[12] =
        crc_reg[4]  ^
        crc_reg[8]  ^
        crc_reg[12] ^
        crc_reg[15] ^
        data_in[0]  ^
        data_in[4]  ^
        data_in[7];

    crc_next[11] =
        crc_reg[3]  ^
        crc_reg[14] ^
        data_in[6];

    crc_next[10] =
        crc_reg[2]  ^
        crc_reg[13] ^
        data_in[5];

    crc_next[9] =
        crc_reg[1]  ^
        crc_reg[12] ^
        data_in[4];

    crc_next[8] =
        crc_reg[0]  ^
        crc_reg[11] ^
        crc_reg[15] ^
        data_in[3]  ^
        data_in[7];

    crc_next[7] =
        crc_reg[10] ^
        crc_reg[14] ^
        crc_reg[15] ^
        data_in[2]  ^
        data_in[6]  ^
        data_in[7];

    crc_next[6] =
        crc_reg[9]  ^
        crc_reg[13] ^
        crc_reg[14] ^
        data_in[1]  ^
        data_in[5]  ^
        data_in[6];

    crc_next[5] =
        crc_reg[8]  ^
        crc_reg[12] ^
        crc_reg[13] ^
        data_in[0]  ^
        data_in[4]  ^
        data_in[5];

    crc_next[4] =
        crc_reg[12] ^
        data_in[4];

    crc_next[3] =
        crc_reg[11] ^
        crc_reg[15] ^
        data_in[3]  ^
        data_in[7];

    crc_next[2] =
        crc_reg[10] ^
        crc_reg[14] ^
        data_in[2]  ^
        data_in[6];

    crc_next[1] =
        crc_reg[9]  ^
        crc_reg[13] ^
        data_in[1]  ^
        data_in[5];

    crc_next[0] =
        crc_reg[8]  ^
        crc_reg[12] ^
        data_in[0]  ^
        data_in[4];
  end

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      crc_reg <= 16'h0000;
    end else if (clear) begin
      crc_reg <= 16'h0000;
    end else if (enable) begin
      crc_reg <= crc_next;
    end
  end

  assign crc_out = crc_reg;

endmodule

// The same byte-wide update written as eight direct polynomial steps.
// The loop bounds are constant, so synthesis unrolls this into combinational
// logic; this is not an eight-cycle implementation.
module crc16_8bit_loop (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        clear,
    input  logic        enable,
    input  logic [7:0]  data_in,
    output logic [15:0] crc_out
);

  logic [15:0] crc_reg;
  logic [15:0] crc_next;

  always_comb begin
    crc_next = crc_reg;
    for (int bit_index = 7; bit_index >= 0; --bit_index) begin
      if (crc_next[15] ^ data_in[bit_index])
        crc_next = (crc_next << 1) ^ 16'h1021;
      else
        crc_next = crc_next << 1;
    end
  end

  always_ff @(posedge clk) begin
    if (!rst_n)
      crc_reg <= 16'h0000;
    else if (clear)
      crc_reg <= 16'h0000;
    else if (enable)
      crc_reg <= crc_next;
  end

  assign crc_out = crc_reg;

endmodule

// Byte-wide CRC update using a 256-entry lookup table.  The table contents
// are constants generated at elaboration time; synthesis may implement them
// as ROM or lower them to muxes depending on the target technology and flow.
module crc16_8bit_table (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        clear,
    input  logic        enable,
    input  logic [7:0]  data_in,
    output logic [15:0] crc_out
);

  logic [15:0] crc_reg;
  logic [15:0] crc_next;
  logic [15:0] lookup [0:255];

  function automatic logic [15:0] make_table_entry(input logic [7:0] index);
    logic [15:0] value;
    value = {index, 8'h00};
    for (int bit_index = 0; bit_index < 8; ++bit_index) begin
      if (value[15])
        value = (value << 1) ^ 16'h1021;
      else
        value = value << 1;
    end
    make_table_entry = value;
  endfunction

  initial begin
    for (int index = 0; index < 256; ++index)
      lookup[index] = make_table_entry(8'(index));
  end

  always_comb begin
    crc_next = {crc_reg[7:0], 8'h00} ^
               lookup[crc_reg[15:8] ^ data_in];
  end

  always_ff @(posedge clk) begin
    if (!rst_n)
      crc_reg <= 16'h0000;
    else if (clear)
      crc_reg <= 16'h0000;
    else if (enable)
      crc_reg <= crc_next;
  end

  assign crc_out = crc_reg;

endmodule

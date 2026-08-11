module crc16_8bit (
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


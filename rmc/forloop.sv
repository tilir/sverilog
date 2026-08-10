//-----------------------------------------------------------------------------
//
// Checking on how for loops work
//
//-----------------------------------------------------------------------------

module forloop;
  bit [31:0] src[5] = '{5{5}};
  logic [31:0] data [10:0];
  int md[2][3] = '{'{0, 1, 2}, '{3, 4, 5}};

  initial
    begin
      $display("-- for loop check --");
      // displays 101, 1, 10.
      $display("src5: %b, %b, %b", src[0], src[0][0], src[0][2:1]);

      $display("for loop tests");
      for (int i = 0; i < $size(data); i++)
        data[i] = (1 << i);
      foreach (data[j])
        $display("%d: %b", j, data[j]);

      $display("md for loop tests");
      md = '{'{9, 8, 7}, '{3{5}}};
      foreach (md[i, j])
        $display("md[%0d][%0d] = %0d", i, j, md[i][j]);
    end
endmodule

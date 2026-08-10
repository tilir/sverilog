//-----------------------------------------------------------------------------
//
// Checking on how reading from file works
//
//-----------------------------------------------------------------------------

module readmem_check;
  logic [3:0] data [0:7];
  initial
    begin
      $display("read mem tests");
      $readmemb("sillyvectors.txt", data);
      foreach (data[i])
        $display("%d: %b", i, data[i]);
    end
endmodule

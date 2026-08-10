//-----------------------------------------------------------------------------
//
// Randomization with some constraints
//
//-----------------------------------------------------------------------------

module randomize;
  class Packet;
    rand int unsigned b;

    function int unsigned value();
      return b;
    endfunction

/* A more involved follow-up experiment:
    rand int a[];
    constraint a_c {
      a.size == 20;
      foreach (a[i]) a[i] inside {1, 2, 3};
      a.sum() with ((item == 1) ? 1 : 0) == 10;
      a.sum() with ((item == 2) ? 1 : 0) == 5;
      a.sum() with ((item == 3) ? 1 : 0) == 5;
    }
*/
  endclass
   
  initial
    begin
      Packet p1;
      int unsigned randomized_value;
      p1 = new();
      if (!1'(p1.randomize())) begin
        $fatal(1, "Randomization error");
      end
      randomized_value = p1.value();
      if ($isunknown(randomized_value)) begin
        $fatal(1, "Randomized value contains X or Z");
      end
      // $display("Value of p1.a is %p", p1.a); 
      $display("Value of p1.b is %0d (0x%08h)",
               randomized_value, randomized_value);
    end
endmodule

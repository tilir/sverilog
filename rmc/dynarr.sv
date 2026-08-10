//-----------------------------------------------------------------------------
//
// Checking on how dynamic data structs work
//
// d1[] -- dynamic array (malloc, realloc, etc)
// q1[$] -- queue (like std::deque)
// h1[*] -- associative
// h2[string] -- associative with string key
//
//-----------------------------------------------------------------------------

module dynarr;
  int d1[], d2[], q1[$] = {3, 4}, q2[$] = {5, 9}, h1[*], h2[string];
  int idx = 1, file;
  string s;

  initial
    begin
      $display("-- dynarr check --");
      d1 = new[5];
      foreach(d1[j])
        d1[j] = j;
      d2 = new[20](d1);
      d1.delete;

      q1.insert(1, 1); // 3, 1, 4
      q1.push_back(1); // 3, 1, 4, 1
      $display("queue q1:");
      foreach(q1[i])
        $display(q1[i]);

      $display("assoc h1:");
      idx = 1;
      repeat(8) begin
        h1[idx] = idx;
        $display("%0d -> %0d", idx, h1[idx]);
        idx = idx << 1;
      end

      file = $fopen("switch.txt", "r");
      while(!$feof(file)) begin
        int i;
        $fscanf(file, "%d %s", i, s);
        h2[s] = i;
        $display("%s -> %0d", s, h2[s]);
      end
    end
endmodule

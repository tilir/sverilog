// Harris and Harris excercise 4.6

// - 0 -
// 5   1
// - 6 -
// 4   2
// - 3 -

module sevensegment(input logic [3:0] data,
                    output logic [6:0] seg);
  always_comb
    begin
      case(data)
      // [top]_[right-down]_[bottom]_[left-up]_[center]
      4'h0: seg = 7'b1_11_1_11_0;
      4'h1: seg = 7'b0_11_0_00_0;
      4'h2: seg = 7'b1_10_1_10_1;
      4'h3: seg = 7'b1_11_1_00_1;
      4'h4: seg = 7'b0_11_0_01_1;
      4'h5: seg = 7'b1_01_1_01_1;
      4'h6: seg = 7'b1_01_1_11_1;
      4'h7: seg = 7'b1_11_0_00_0;
      4'h8: seg = 7'b1_11_1_11_1;
      4'h9: seg = 7'b1_11_1_01_1;
      4'hA: seg = 7'b1_11_0_11_1;
      4'hB: seg = 7'b0_01_1_11_1;
      4'hC: seg = 7'b1_00_1_11_0;
      4'hD: seg = 7'b0_11_1_10_1;
      4'hE: seg = 7'b1_00_1_11_1;
      4'hF: seg = 7'b1_00_0_11_1;
      default: seg = 7'h0;
      endcase
    end
endmodule;

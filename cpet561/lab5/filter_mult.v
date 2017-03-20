`timescale 1 ns / 100 ps

module filter_mult (
  dataa,
  datab,
  result
);
  // Ports
  input [35:0] dataa;
  input [35:0] datab;
  output [71:0] result;
  
  reg [71:0] result_reg;
  reg [35:0] dataa_comp;
  reg [35:0] datab_comp;
  reg [71:0] dataa_ext;
  reg [71:0] datab_ext;
  reg [1:0] sign;

  always @(dataa, datab) begin
    if ((dataa[35] == 1'b0) && (datab[35] == 1'b0)) begin
      sign = 2'b00;
      result_reg = dataa * datab;
    end
    else if ((dataa[35] == 1'b1) && (datab[35] == 1'b1)) begin
      sign = 2'b11;
      dataa_comp = (~dataa) + 36'h1;
      datab_comp = (~datab) + 36'h1;
      result_reg = dataa_comp * datab_comp;
    end
    else begin
      sign = 2'b10;
      dataa_ext = {{36{dataa[35]}}, dataa};
      datab_ext = {{36{datab[35]}}, datab};
      result_reg = dataa_ext * datab_ext;
    end
  end
  
  assign result = result_reg;
  
endmodule
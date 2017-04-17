// --------------------------------------------------------------------
// CODEC ADC interface
// Copyright (c) 2016 Evergreen Embedded Development Inc.
// Written by Gregg Guarino Ph.D.
// February 27, 2016
// --------------------------------------------------------------------

`timescale 1 ns / 100 ps

module codec_adc_interface (i_clk_50,
                            i_AUD_ADCDAT,
                            i_adclrckFallingEdge,
                            i_adclrckRisingEdge,
                            i_bclkRisingEdge,
                            o_audioSampleADC,
                            o_dataReady );
  
  // Ports
  input i_clk_50;
  input i_AUD_ADCDAT;
  input i_adclrckFallingEdge;
  input i_adclrckRisingEdge;
  input i_bclkRisingEdge;
  output [31:0] o_audioSampleADC;
  output o_dataReady;
 
  // Internal signals
  reg  [15:0] shiftRegRight;
  reg  [15:0] shiftRegLeft;
  reg dataReady;
  reg [4:0] acquireLeft;
  reg [4:0] acquireRight;
  
  // Assignments
  assign o_audioSampleADC = {shiftRegLeft, shiftRegRight};
  assign o_dataReady = dataReady;

  // Load the shift register on the edge of DACLRC
  always @(posedge i_clk_50) begin
    if (i_adclrckFallingEdge) begin
      // Falling edge, left channel
      acquireLeft <= 5'd17;
      dataReady <= 1'b1;
    end
    else if (i_adclrckRisingEdge) begin
      // Rising edge, right channel
      acquireRight <= 5'd17;
    end
    else if ((acquireLeft != 5'd0) && i_bclkRisingEdge) begin
      acquireLeft <= acquireLeft - 5'd1;
      shiftRegLeft[0] <= i_AUD_ADCDAT;
      shiftRegLeft[15:1] <= shiftRegLeft[14:0];
    end
    else if ((acquireRight != 5'd0) && i_bclkRisingEdge) begin
      acquireRight <= acquireRight - 5'd1;
      shiftRegRight[0] <= i_AUD_ADCDAT;
      shiftRegRight[15:1] <= shiftRegRight[14:0];
    end
    else begin
      dataReady <= 1'b0;
    end
  end
  
endmodule
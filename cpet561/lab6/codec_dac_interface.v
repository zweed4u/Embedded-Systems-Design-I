// --------------------------------------------------------------------
// CODEC DAC interface
// Copyright (c) 2016 Evergreen Embedded Development Inc.
// Written by Gregg Guarino Ph.D.
// February 29, 2016
// --------------------------------------------------------------------

`timescale 1 ns / 100 ps

module codec_dac_interface (i_clk_50,
                            i_audioSample, 
                            i_daclrckFallingEdge,
                            i_daclrckRisingEdge,
                            i_bclkRisingEdge,
                            o_dataReq, 
                            o_AUD_DACDAT);

  // Ports
  input i_clk_50;
  input [31:0] i_audioSample;
  input i_daclrckFallingEdge;
  input i_daclrckRisingEdge;
  input i_bclkRisingEdge;
  output o_dataReq;
  output o_AUD_DACDAT;
  
  // Internal signals
  reg  [16:0] shiftReg;
  reg  AUD_BCLK_d1;
  reg  AUD_BCLK_d2;
  reg  AUD_BCLK_d3;
  reg  AUD_BCLK_d4;
  reg  AUD_DACLRCK_d1;
  reg  AUD_DACLRCK_d2;
  reg  AUD_DACLRCK_d3;
  reg  AUD_DACLRCK_d4;
  reg  dataReq;
  reg  latchAudioSample;

  // Assignments
  assign o_AUD_DACDAT = shiftReg[16];
  assign o_dataReq = dataReq;

  // Load the shift register on the edge of DACLRC
  always @(posedge i_clk_50) begin
    if (i_daclrckFallingEdge) begin
      // Falling edge, left channel
      dataReq <= 1'b1;
    end
    else if (dataReq == 1'b1) begin
      latchAudioSample = 1'b1;
      dataReq <= 1'b0;
    end
    else if (latchAudioSample == 1'b1) begin
      latchAudioSample = 1'b0;
      shiftReg[15:0] <= i_audioSample[31:16];
    end
    else if (i_daclrckRisingEdge) begin
      // Rising edge, right channel
      shiftReg[15:0] <= i_audioSample[15:0];
    end
    else if (i_bclkRisingEdge) begin
      // Rising edge of audio bit clock
      shiftReg[16:1] <= shiftReg[15:0];
      shiftReg[0] <= 1'b0;
    end
  end
endmodule
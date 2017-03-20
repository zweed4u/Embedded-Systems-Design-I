// --------------------------------------------------------------------
// Filter testbench
// Gregg Guarino Ph.D.
// May 5, 2016
// --------------------------------------------------------------------

`timescale 1 ns / 100 ps

module test_filter_tb ();
  wire signed [31:0] audioSample_w;
  wire signed [31:0] audioSampleFiltered_w;
  reg clk_50;
  reg reset;
  reg dataReq;
  reg signed [15:0] audioSampleArray[39:0];
  reg signed [15:0] audioSample;
  reg signed [15:0] audioSampleFiltered;
  integer fileIn, fileOut, status, i;
  
  // ---------- Instantiate the DUT ----------
  audio_filter audio_filter_inst (
    .i_clk_50(clk_50),
    .i_reset(reset),
    .i_audioSample(audioSample_w),
    .i_dataReq(dataReq),
    .i_filterReset(1'b0),
    .o_audioSampleFiltered(audioSampleFiltered_w)
  );
  
  // Assignments
  assign audioSample_w = {audioSample, audioSample};
  
  // Generate the 50MHz clock
  always #10 clk_50 = ~clk_50;
  
  // Initialize and generate reset
  initial begin
    clk_50 = 1'b0;
    reset = 1'b1;
    dataReq = 1'b0;
    #2000 reset = 1'b0;
  end
  
  // Apply test vectors to the DUT
  initial begin
    // Open files
    fileIn = $fopen("one_cycle_200_8k.csv", "r");
    fileOut = $fopen("filter_out.csv", "w");
    // Load a cycle of the input waveform into an array
    for (i=0; i<40; i=i+1) begin
      status = $fscanf(fileIn, "%h\n", audioSampleArray[i]);
    end // for
    $fclose(fileIn);
    // Apply the test data and put the result into an output file
    repeat (100) begin
      for (i=0; i<40; i=i+1) begin
        repeat (1100) begin
          @(posedge clk_50);
        end // repeat
        audioSample = audioSampleArray[i];
        audioSampleFiltered = audioSampleFiltered_w[15:0];
        $fwrite(fileOut, "%d\n", ($signed(audioSampleFiltered)));
        repeat (2) begin
          @(posedge clk_50);
        end // repeat
        dataReq = 1'b1;
        @(posedge clk_50);
        dataReq = 1'b0;
      end // for
    end //repeat
    $fclose(fileIn);
    $stop;
  end // initial
  
endmodule

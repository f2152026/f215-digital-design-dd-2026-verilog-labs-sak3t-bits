// tb.v
// Starter testbench template -- YOU complete this file.

module tb;

  reg  [1:0] t_sel;   
  wire [7:0] t_dout;  


  // TODO: instantiate DUT here
  lut DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    // TODO: apply different input combinations
  #5; t_sel = 2'd0;
  #5; t_sel = 2'd1;
  #5; t_sel = 2'd2;
  #5; t_sel = 2'd3;

  end

  initial
    $monitor($time, " sel=%b dout=%b (%0d)", t_sel, t_dout, t_dout); // change as required

endmodule

module tb;

  reg [1:0]t_a, t_b;
  wire t_gt, t_lt, t_eq;

  integer errors;
  integer total;

  comp2 DUT (
      .A (t_a),
      .B (t_b),
      .GT(t_gt),
      .LT(t_lt),
      .EQ(t_eq)
  );

  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  // Self-checking task: compares DUT outputs against independently
  // computed expected values and tallies errors.
  task check;
    reg exp_gt, exp_lt, exp_eq;
    begin
      exp_gt = (t_a > t_b);
      exp_lt = (t_a < t_b);
      exp_eq = (t_a == t_b);

      total = total + 1;

      if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
        $display("FAIL at time %0t: A=%b B=%b  got GT=%b LT=%b EQ=%b  expected GT=%b LT=%b EQ=%b",
                 $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;
    total  = 0;

    t_a = 2'b00; t_b = 2'b00; #1 check;
    #4 t_a = 2'b00; t_b = 2'b01; #1 check;
    #4 t_a = 2'b00; t_b = 2'b10; #1 check;
    #4 t_a = 2'b00; t_b = 2'b11; #1 check;
    #4 t_a = 2'b01; t_b = 2'b00; #1 check;
    #4 t_a = 2'b01; t_b = 2'b01; #1 check;
    #4 t_a = 2'b01; t_b = 2'b10; #1 check;
    #4 t_a = 2'b01; t_b = 2'b11; #1 check;
    #4 t_a = 2'b10; t_b = 2'b00; #1 check;
    #4 t_a = 2'b10; t_b = 2'b01; #1 check;
    #4 t_a = 2'b10; t_b = 2'b10; #1 check;
    #4 t_a = 2'b10; t_b = 2'b11; #1 check;
    #4 t_a = 2'b11; t_b = 2'b00; #1 check;
    #4 t_a = 2'b11; t_b = 2'b01; #1 check;
    #4 t_a = 2'b11; t_b = 2'b10; #1 check;
    #4 t_a = 2'b11; t_b = 2'b11; #1 check;

    $write("SUMMARY: %0d / %0d passed", total - errors, total);
    if (errors == 0)
      $display(" -- ALL TESTS PASSED");
    else
      $display(" -- %0d FAILURES", errors);

    #4 $finish;
  end

  initial
    $monitor($time, " A=%b B=%b | GT=%b LT=%b EQ=%b", t_a, t_b, t_gt, t_lt, t_eq);

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2025 11:43:11 AM
// Design Name: 
// Module Name: Division_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Division_tb;

  // Parameters
  parameter N = 4;

  // Inputs
  logic clk;
  logic resetn;
  logic [N-1:0] dividend;
  logic [N-1:0] divisor;
  logic start;

  // Outputs
  logic [N-1:0] quotient;
  logic [N-1:0] remainder;
  logic error;
  logic done;

  // Instantiate DUT
  Division #(.N(N)) dut (
    .clk(clk),
    .resetn(resetn),
    .dividend(dividend),
    .divisor(divisor),
    .start(start),
    .quotient(quotient),
    .remainder(remainder),
    .error(error),
    .done(done)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // Task for division
  task divide(input logic [N-1:0] a, input logic [N-1:0] b);
    begin
      @(negedge clk);
      dividend <= a;
      divisor  <= b;
      start    <= 1;

      @(negedge clk);
      start <= 0;

      wait (done);
      #10;
    end
  endtask

  initial begin
    // Initial values
    dividend = 0;
    divisor = 0;
    start = 0;
    resetn = 0;

    // Reset
    #10;
    resetn = 1;
    #10;

    // Test case 1: 13 / 3 = 4, R=1
    divide(4'd13, 4'd3);

    // Test case 2: Divide by zero
    divide(4'd7, 4'd0);

    // Test case 3: 8 / 2 = 4, R=0
    divide(4'd8, 4'd2);

    #10;
    $finish;
  end

endmodule



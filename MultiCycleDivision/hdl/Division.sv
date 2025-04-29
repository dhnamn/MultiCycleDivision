`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2025 11:38:23 AM
// Design Name: 
// Module Name: Division
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


module Division
#(parameter N = 4) // Width of dividend and division
(
    input clk,
    input resetn,
    input [N-1:0] dividend,
    input [N-1:0] divisor,
    input start,
    
    output logic [N-1:0] quotient,
    output logic [N-1:0] remainder,
    output logic error,
    output logic done 
    );
    
    logic [$clog2(N):0] count;
    logic [N-1:0] a,b;
    // Error check
    always_comb begin
        if (b == 0) begin
            error = 1;
        end else begin
            error = 0;
        end
    end
    
    // Count reg update
    always_ff @(posedge clk, negedge resetn) begin
        if (!resetn) begin
            count <= 0;
        end else if (start) begin
            count <= N;
        end else if (count != 0) begin
            count <= count - 1;
        end
    end
    
    // Tempotary dividend update
    always_ff @(posedge clk, negedge resetn) begin
        if (!resetn) begin
            a <= 0;
        end else if (start) begin
            a <= dividend;
        end else if (count != 0) begin
            a <= a << 1;
        end
    end
    
    // Tempotary divisor update
    always_ff @(posedge clk, negedge resetn) begin
        if (!resetn) begin
            b <= 1;
        end else if (start) begin
            b <= divisor;
        end
    end
    
    // Remainder update
    always_ff @(posedge clk, negedge resetn) begin
        if (!resetn) begin
            remainder <= 0;
        end else if (start) begin
            remainder <= 0;
        end else if (count != 0) begin
            if (remainder >= b) begin
                remainder <= ((remainder - b) << 1) + a[N-1];
            end else begin
                remainder <= (remainder << 1) + a[N-1];
            end
        end
    end 
    
    // Quotient update
    always_ff @(posedge clk, negedge resetn) begin
        if (!resetn) begin
            quotient <= 0;
        end else if (start) begin
            quotient <= 0;
        end else if (count != 0) begin
            if (remainder >= b) begin
                quotient <= (quotient + 1) << 1;
            end else begin
                quotient <= (quotient << 1);
            end
        end
    end 
    
    // Done flag update
    always_ff @(posedge clk, negedge resetn) begin
        if (!resetn) begin
            done <= 0;
        end else if (start) begin
            done <= 0;
        end else if (count == 1 | error) begin
            done <= 1;
        end
    end
endmodule

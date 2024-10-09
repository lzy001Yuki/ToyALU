`timescale 1ns / 1ps

`include"float_adder.v"
module test;
   reg clk, rst, flag;
    reg [31:0] x, y;
    wire [31:0] z;

    float_adder float_adder(
              .clk(clk),
              .rst(rst),
              .a(x),
              .b(y),
              .s(z)
          );

    always #(10) clk<=~clk;

    initial begin
        clk = 0;
        rst = 0;
        flag = 1;
        #20 rst = 1;


        x = 32'h4e32a8b6;
        y = 32'hce9b8a1f;
        #1000
         $display("%b + %b = %h", x, y, z);
        if (z != 32'hce046b88) begin
            $display("Wrong Answer!");
            flag = 0;
        end
        else begin
            $display("Correct!");
        end

        x = 32'hce28495b;
        y = 32'hce904f23;
        #10
         $display("%b + %b = %h", x, y, z);
        if (z != 32'hcee473d0) begin
            $display("Wrong Answer!");
            flag = 0;
        end
        else begin
            $display("Correct!");
        end

        x = 32'h4d905610;
        y = 32'h4c3c1864;
        #1000
         $display("%b + %b = %b", x, y, z);
        if (z != 32'h4da7d91c) begin
            $display("Wrong Answer!");
            flag = 0;
        end
        else begin
            $display("Correct!");
        end

        x = 32'hcd6f9230;
        y = 32'h4e0e5d70;
        #1000
         $display("%b + %b = %b", x, y, z);
        if (z != 32'h4da4f1c8) begin
            $display("Wrong Answer!");
            flag = 0;
        end
        else begin
            $display("Correct!");
        end

        x = 32'hce55e840;
        y = 32'h4c65a940;
        #1000
         $display("%b + %b = %b", x, y, z);
        if (z != 32'hce478dac) begin
            $display("Wrong Answer!");
            flag = 0;
        end
        else begin
            $display("Correct!");
        end

        x = 32'hcee1599c;
        y = 32'hce926b1c;
        #1000
         $display("%b + %b = %b", x, y, z);
        if (z != 32'hcf39e25c) begin
            $display("Wrong Answer!");
            flag = 0;
        end
        else begin
            $display("Correct!");
        end

        x = 32'h4ea27aab;
        y = 32'hce9ff632;
        #1000
         $display("%b + %b = %b", x, y, z);
        if (z != 32'h4ba11e40) begin
            $display("Wrong Answer!");
            flag = 0;
        end
        else begin
            $display("Correct!");
        end

        if (flag == 1) begin
            $display("All test cases passed!");
        end
        else begin
            $display("Some test cases failed!");
        end

        $finish;
    end

endmodule
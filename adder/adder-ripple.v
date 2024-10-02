/* ACM Class System (I) Fall Assignment 1 
 *
 *
 * Implement your naive adder here
 * 
 * GUIDE:
 *   1. Create a RTL project in Vivado
 *   2. Put this file into `Sources'
 *   3. Put `test_adder.v' into `Simulation Sources'
 *   4. Run Behavioral Simulation
 *   5. Make sure to run at least 100 steps during the simulation (usually 100ns)
 *   6. You can see the results in `Tcl console'
 *
 */

module adder(
	input [31:0] a,
	input [31:0] b,
	output reg [31:0] out
);
	integer i;
	reg val[31:0];
	reg carry[31:0];
	reg sum[31:0];
	always @(*) begin
		for (i = 0; i < 32; i++) {
			val[i] = a[i] & b[i];
			carry[i] = a[i] | b[i];
		}
		sum[0] = 1'b0;
		for (i = 0; i < 31; i++) {
			sum[i+1]=(sum[i] & carry[i]) | val[i];
		}
		for (i = 0; i < 32; i++) {
			out[i] = sum[i] ^ a[i] * b[i];
		}
	end
	
endmodule

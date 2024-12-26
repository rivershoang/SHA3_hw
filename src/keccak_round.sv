module keccak_round (
   input  logic clk,
   input  logic reset_n,
	input  logic [1599:0] S_in,
	output logic [1599:0] S_out,

   output logic finish
);
	logic [63:0] A_in      [0:4][0:4];
	logic [63:0] A_in_mid  [0:4][0:4];
	logic [63:0] A_mid_out [0:4][0:4];
	logic [63:0] A_out     [0:4][0:4];
	logic [ 4:0] round;

	string_to_array STA (
      .S(S_in), 
      .A(A_in)
   );

	round_counter rndcnt (
      .clk     (clk)    , 
      .reset_n (reset_n), 
      .round   (round)
   );

	assign A_in_mid = (round == 0) ? A_in : A_out;

	round rnd_inst (
      .A_in (A_in_mid), 
      .i_r  (round), 
      .A_out(A_mid_out)
   );

	always_ff @(posedge clk or negedge reset_n)
		if (~reset_n)
			for (int x = 0; x < 5; x = x + 1) begin : reset_x
				for (int y = 0; y < 5; y = y + 1) begin : reset_y
					A_out[x][y] = 0;
				end
			end

		else if (round == 24)
			for (int x = 0; x < 5; x = x + 1) begin : full_x
				for (int y = 0; y < 5; y = y + 1) begin : full_y
					A_out[x][y] = 0;
				end
			end

		else A_out = A_mid_out;

	array_to_string ATS (
      .A(A_out), 
      .S(S_out)
   );

	assign finish = (round == 24) & squeeze;

endmodule
   


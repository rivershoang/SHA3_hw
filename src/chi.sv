import keccak_pkg::plane;
import keccak_pkg::state;
import keccak_pkg::N;

module chi (
	input  state A_in  ,
	output state A_out
);

	logic	[2:0] x_add1, x_add2;

	integer x,y,z;

	always_comb begin
		for (y = 0; y < 5; y++)
			for (x = 0; x < 5; x++)
				for (z = 0; z < N; z++) begin
					if (x == 3) begin x_add1 = 4; x_add2 = 0; end
					if (x == 4) begin x_add1 = 0; x_add2 = 1; end
					if (x != 3 && x != 4) begin x_add1 = x + 1; x_add2 = x + 2; end;
					A_out[y][x][z] = A_in[y][x][z] ^ ((A_in[y][x_add1][z] ^ 1) & A_in[y][x_add2][z]);
				end
		end

endmodule

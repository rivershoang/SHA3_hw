`include "../src/keccak_pkg.sv"
import keccak_pkg::plane;
import keccak_pkg::state;
import keccak_pkg::N;

module pi (
	input  state A_in, 
	output state A_out 
);

	integer x,y,z;

	always_comb begin
		for (y = 0; y < 5; y++)
			for (x = 0; x < 5; x++)
				for (z = 0; z < N; z++)
				A_out[y][x][z] = A_in[x][(x+3*y)%5][z];
	end

endmodule
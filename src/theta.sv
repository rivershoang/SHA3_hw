`include "../src/keccak_pkg.sv"
import keccak_pkg::plane;
import keccak_pkg::state;
import keccak_pkg::N;

module theta (
	input  state A_in,
	output state A_out
);

	plane	c,
			d;
	logic [N-1:0] z_sub;
	logic	[	2:0] x_sub, x_add;

	integer x,y,z;

	always_comb begin
		for (x = 0; x < 5; x++)
			for (z = 0; z < 64; z++)
				c[x][z] = A_in[0][x][z] ^ A_in[1][x][z] ^ A_in[2][x][z] ^ A_in[3][x][z] ^ A_in[4][x][z];
	end

	integer xi,zi;

	always_comb begin
		for (xi = 0; xi < 5; xi++)
			for (zi = 0; zi < 64; zi++)
				begin
					if (xi == 0) x_sub = 4; 
					else x_sub = xi - 1;
					if (xi == 4) x_add = 0; 
					else x_add = xi + 1;
					if (zi == 0) z_sub = 63; 
					else z_sub = zi - 1; 
					d[xi][zi] = c[x_sub][zi] ^ c[x_add][z_sub];
				end
	end

	integer xii, yii, zii;

	always_comb begin
		for (yii = 0; yii < 5; yii++)
			for (xii = 0; xii < 5; xii++)
				for (zii = 0; zii < 64; zii++)
					A_out[yii][xii][zii] = A_in[yii][xii][zii] ^ d[xii][zii];
	end

endmodule

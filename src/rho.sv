import keccak_pkg::plane;
import keccak_pkg::state;
import keccak_pkg::N;
import keccak_pkg::ABS;

module rho (
	input  state A_in  ,
	output state A_out
);

	always_comb begin
		for (int z = 0; z < N; z++) begin	
			A_out[0][0][z] = A_in[0][0][z];			//y=0, x=0
			if (z-1 >= 0)  A_out[0][1][z] = A_in[0][1][z-1];	//y=0, x=1
			else A_out[0][1][z] = A_in[0][1][z-1+64];
			if (z-62 >= 0) A_out[0][2][z] = A_in[0][2][z-62];
			else A_out[0][2][z] = A_in[0][2][z-62+64];
			if (z-28 >= 0) A_out[0][3][z] = A_in[0][3][z-28];
			else A_out[0][3][z] = A_in[0][3][z-28+64];
			if (z-27 >= 0) A_out[0][4][z] = A_in[0][4][z-27];
			else A_out[0][4][z] = A_in[0][4][z-27+64];

        		
			if (z-36 >= 0) A_out[1][0][z] = A_in[1][0][z-36];
			else A_out[1][0][z] = A_in[1][0][z-36+64];
			if (z-44 >= 0)  A_out[1][1][z] = A_in[1][1][z-44];	
			else A_out[1][1][z] = A_in[1][1][z-44+64];
			if (z-6 >= 0) A_out[1][2][z] = A_in[1][2][z-6];
			else A_out[1][2][z] = A_in[1][2][z-6+64];
			if (z-55 >= 0) A_out[1][3][z] = A_in[1][3][z-55];
			else A_out[1][3][z] = A_in[1][3][z-55+64];
			if (z-20 >= 0) A_out[1][4][z] = A_in[1][4][z-20];
			else A_out[1][4][z] = A_in[1][4][z-20+64];


			if (z-3 >= 0) A_out[2][0][z] = A_in[2][0][z-3];
			else A_out[2][0][z] = A_in[2][0][z-3+64];
			if (z-10 >= 0)  A_out[2][1][z] = A_in[2][1][z-10];	
			else A_out[2][1][z] = A_in[2][1][z-10+64];
			if (z-43 >= 0) A_out[2][2][z] = A_in[2][2][z-43];
			else A_out[2][2][z] = A_in[2][2][z-43+64];
			if (z-25 >= 0) A_out[2][3][z] = A_in[2][3][z-25];
			else A_out[2][3][z] = A_in[2][3][z-25+64];
			if (z-39 >= 0) A_out[2][4][z] = A_in[2][4][z-39];
			else A_out[2][4][z] = A_in[2][4][z-39+64];


			if (z-41 >= 0) A_out[3][0][z] = A_in[3][0][z-41];
			else A_out[3][0][z] = A_in[3][0][z-41+64];
			if (z-45 >= 0)  A_out[3][1][z] = A_in[3][1][z-45];	
			else A_out[3][1][z] = A_in[3][1][z-45+64];
			if (z-15 >= 0) A_out[3][2][z] = A_in[3][2][z-15];
			else A_out[3][2][z] = A_in[3][2][z-15+64];
			if (z-21 >= 0) A_out[3][3][z] = A_in[3][3][z-21];
			else A_out[3][3][z] = A_in[3][3][z-21+64];
			if (z-8 >= 0) A_out[3][4][z] = A_in[3][4][z-8];
			else A_out[3][4][z] = A_in[3][4][z-8+64];
						
        		
			if (z-18 >= 0) A_out[4][0][z] = A_in[4][0][z-18];
			else A_out[4][0][z] = A_in[4][0][z-18+64];
			if (z-2 >= 0)  A_out[4][1][z] = A_in[4][1][z-2];	
			else A_out[4][1][z] = A_in[4][1][z-2+64];
			if (z-61 >= 0) A_out[4][2][z] = A_in[4][2][z-61];
			else A_out[4][2][z] = A_in[4][2][z-61+64];
			if (z-56 >= 0) A_out[4][3][z] = A_in[4][3][z-56];
			else A_out[4][3][z] = A_in[4][3][z-56+64];
			if (z-14 >= 0) A_out[4][4][z] = A_in[4][4][z-14];
			else A_out[4][4][z] = A_in[4][4][z-14+64];
		end
	end

endmodule
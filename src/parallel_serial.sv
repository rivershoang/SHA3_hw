module parallel_serial (
	input  logic				clk,
	input  logic 				reset_n,
	input  logic [1599:0] 	S_out,
	// input  logic [ 10 :0] 	d,
	input	 logic				ready,
	output logic [ 63: 0] 	S_out_serial,
	output logic				finish_hash
);
	
	logic 	[7:0] array_out [0:127];
	integer 	i;

	always_comb begin
	   {array_out[7], array_out[6], array_out[5], array_out[4], array_out[3], array_out[2], array_out[1], array_out[0]}			=	S_out[63:0];
	   {array_out[15], array_out[14], array_out[13], array_out[12], array_out[11], array_out[10], array_out[9], array_out[8]}			=	S_out[127:64];
	   {array_out[23], array_out[22], array_out[21], array_out[20], array_out[19], array_out[18], array_out[17], array_out[16]}		=	S_out[191:128];
	   {array_out[31], array_out[30], array_out[29], array_out[28], array_out[27], array_out[26], array_out[25], array_out[24]}		=	S_out[255:192];
	   {array_out[39], array_out[38], array_out[37], array_out[36], array_out[35], array_out[34], array_out[33], array_out[32]}		=	S_out[319:256];
	   {array_out[47], array_out[46], array_out[45], array_out[44], array_out[43], array_out[42], array_out[41], array_out[40]}		=	S_out[383:320];
	   {array_out[55], array_out[54], array_out[53], array_out[52], array_out[51], array_out[50], array_out[49], array_out[48]}		=	S_out[447:384];
	   {array_out[63], array_out[62], array_out[61], array_out[60], array_out[59], array_out[58], array_out[57], array_out[56]}		=	S_out[511:448];
	   {array_out[71], array_out[70], array_out[69], array_out[68], array_out[67], array_out[66], array_out[65], array_out[64]}		=	S_out[575:512];
	   {array_out[79], array_out[78], array_out[77], array_out[76], array_out[75], array_out[74], array_out[73], array_out[72]}		=	S_out[639:576];
	   {array_out[87], array_out[86], array_out[85], array_out[84], array_out[83], array_out[82], array_out[81], array_out[80]}		=	S_out[703:640];
	   {array_out[95], array_out[94], array_out[93], array_out[92], array_out[91], array_out[90], array_out[89], array_out[88]}		=	S_out[767:704];
	   {array_out[103], array_out[102], array_out[101], array_out[100], array_out[99], array_out[98], array_out[97], array_out[96]}		=	S_out[831:768];
	   {array_out[111], array_out[110], array_out[109], array_out[108], array_out[107], array_out[106], array_out[105], array_out[104]}	=	S_out[895:832];
	   {array_out[119], array_out[118], array_out[117], array_out[116], array_out[115], array_out[114], array_out[113], array_out[112]}	=	S_out[959:896];
	   {array_out[127], array_out[126], array_out[125], array_out[124], array_out[123], array_out[122], array_out[121], array_out[120]}	=	S_out[1023:960];
	end

always_ff @(posedge clk or negedge reset_n) begin
	if (!reset_n) begin
		S_out_serial <= 0; 
      finish_hash <= 0; 
      i <= 0; 
	end else begin
		if (ready)
			if (i < 4) begin
					S_out_serial <= {array_out[i*8], array_out[i*8+1], array_out[i*8+2], array_out[i*8+3], array_out[i*8+4], array_out[i*8+5], array_out[i*8+6], array_out[i*8+7]}; // 64 bit
               //S_out_serial <= {array_out[i*4], array_out[i*4+1], array_out[i*4+2], array_out[i*4+3]}; // 64 bit
               i = i + 1;
				end	
			else finish_hash <= 1;
		end
	end

endmodule
module control_unit (clk, rst_n, start, last, buff_full, first, finish, valid, nxt_block, en_vsx, en_counter, ready);
	input 	logic clk, 
						rst_n;
	input		logic	start, 
						last, 
						buff_full, 
						first, 
						finish;
	output	logic	valid, 
						nxt_block, 
						en_vsx, 
						en_counter, 
						ready;

	typedef enum logic [2:0] {
		INIT,
		START,
		FULL_DATA,
		WAIT_DATA,
		EX_FIRST_BLOCK,
		EX_BLOCK,
		DONE
	} state_e;
	
	// 	typedef enum logic [3:0] {
	// 	S1,
	// 	S2,
	// 	S3,
	// 	S4,
	// 	S5,
	// 	S6,
	// 	S7,
	// 	S8,
	// 	S9
	// } state_e;

	state_e current_state;
	state_e next_state;
	
	always_ff @(posedge clk or negedge rst_n) begin
		if (!rst_n) current_state 	<= INIT;
		else current_state 			<= next_state;
	end

	
	always_comb begin
		case (current_state)
		INIT: begin
			if (start) 	next_state = START;
			else 			next_state = INIT;
			valid 		= 0; 
			nxt_block 	= 0; 
			en_vsx 		= 0; 
			en_counter 	= 0; 
			ready 		= 0;
		end
		START: begin
			if (last) 	next_state = FULL_DATA;
			else 			next_state = WAIT_DATA;	
			valid 		= 1; 
			nxt_block 	= 0; 
			en_vsx 		= 0; 
			en_counter 	= 0; 
			ready 		= 0;
		end
		FULL_DATA: begin
			if (buff_full) begin
				if (first) 	next_state = EX_FIRST_BLOCK;
				else 			next_state = EX_BLOCK;
			end else 		next_state = FULL_DATA;
			valid 		= 0; 
			nxt_block 	= 0; 
			en_vsx 		= 1;
			en_counter 	= 0; 
			ready 		= 0;
		end
		WAIT_DATA: begin
			if (last && !first)		next_state = EX_BLOCK;	
			else if (last && first) next_state = EX_FIRST_BLOCK;
			else 							next_state = WAIT_DATA;
			valid 		= 1; 
			nxt_block 	= 0; 
			en_vsx 		= 1; 
			en_counter 	= 0; 
			ready 		= 0;
		end
		EX_FIRST_BLOCK: begin
			if (finish) next_state = DONE;
			else 			next_state = EX_FIRST_BLOCK;
			valid 		= 0; 
			nxt_block 	= 0; 
			en_vsx 		= 1; 
			en_counter 	= 1; 
			ready 		= 0;
		end
		EX_BLOCK: begin
			if (finish) next_state = DONE;
			else 			next_state = EX_BLOCK;
			valid 		= 0; 
			nxt_block 	= 1; 
			en_vsx 		= 1; 
			en_counter 	= 1; 
			ready 		= 0;
		end
		DONE: begin
			next_state 	= DONE;
			valid 		= 0; 
			nxt_block 	= 0; 
			en_vsx 		= 0; 
			en_counter 	= 0; 
			ready 		= 1;
		end
	default: begin
		next_state 	= INIT;
		valid 		= 0; 
		nxt_block 	= 0; 
		en_vsx 		= 0; 
		en_counter 	= 0; 
		ready 		= 0;
		end
	endcase
	end

	// always_comb begin
	// 	case (current_state)
	// 	S1: begin
	// 		if (start) 	next_state = S2;
	// 		else 			next_state = S1;
	// 		valid 		= 0; 
	// 		nxt_block 	= 0; 
	// 		en_vsx 		= 0; 
	// 		en_counter 	= 0; 
	// 		ready 		= 0;
	// 	end
	// 	S2: begin
	// 		if (last) 	next_state = S3;
	// 		else 			next_state = S4;	
	// 		valid 		= 1; 
	// 		nxt_block 	= 0; 
	// 		en_vsx 		= 0; 
	// 		en_counter 	= 0; 
	// 		ready 		= 0;
	// 	end
	// 	S3: begin
	// 			if (buff_full) begin
	// 				if (first) 	next_state = S5;
	// 				else 			next_state = S6;
	// 			end else 		next_state = S3;
	// 			valid 		= 0; 
	// 			nxt_block 	= 0; 
	// 			en_vsx 		= 1;
	// 			en_counter 	= 0; 
	// 			ready 		= 0;
	// 	end
	// 	S4: begin
	// 		if (!first && buff_full && !last) 	next_state = S8;
	// 		else if (first && buff_full) 			next_state = S7;
	// 		else if (last && !first) 				next_state = S6;	
	// 		else if (last && first) 				next_state = S5;
	// 		else 											next_state = S4;
	// 		valid 		= 1; 
	// 		nxt_block 	= 0; 
	// 		en_vsx 		= 1; 
	// 		en_counter 	= 0; 
	// 		ready 		= 0;
	// 	end
	// 	S5: begin
	// 		if (finish) next_state = S9;
	// 		else 			next_state = S5;
	// 		valid 		= 0; 
	// 		nxt_block 	= 0; 
	// 		en_vsx 		= 1; 
	// 		en_counter 	= 1; 
	// 		ready 		= 0;
	// 	end
	// 	S6: begin
	// 		if (finish) next_state = S9;
	// 		else 			next_state = S6;
	// 		valid 		= 0; 
	// 		nxt_block 	= 1; 
	// 		en_vsx 		= 1; 
	// 		en_counter 	= 1; 
	// 		ready 		= 0;
	// 	end
	// 	S7: begin
	// 		if (finish) next_state = S2;
	// 		else 			next_state = S7;
	// 		valid 		= 0; 
	// 		nxt_block 	= 0; 
	// 		en_vsx 		= 1; 
	// 		en_counter 	= 1; 
	// 		ready 		= 0;
	// 	end
	// 	S8: begin
	// 		if (finish) next_state = S2;
	// 		else 			next_state = S8;
	// 		valid 		= 0; 
	// 		nxt_block 	= 1; 
	// 		en_vsx 		= 1; 
	// 		en_counter 	= 1; 
	// 		ready 		= 0;
	// 	end
	// 	S9: begin
	// 		next_state 	= S9;
	// 		valid 		= 0; 
	// 		nxt_block 	= 0; 
	// 		en_vsx 		= 0; 
	// 		en_counter 	= 0; 
	// 		ready 		= 1;
	// 	end
	// default: begin
	// 	next_state 	= S1;
	// 	valid 		= 0; 
	// 	nxt_block 	= 0; 
	// 	en_vsx 		= 0; 
	// 	en_counter 	= 0; 
	// 	ready 		= 0;
	// 	end
	// endcase
	// end

endmodule


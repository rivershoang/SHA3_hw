module control_unit (clk, rst_n, start, last, buff_full, first, finish, valid, nxt_block, en_vsx, en_counter, ready,read_data_fifo);
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
						read_data_fifo,
						ready;

	typedef enum logic [3:0] {
		INIT,
		START,
		PREPARE_DATA,
		FULL_DATA,
		WAIT_DATA,
		EX_FIRST_BLOCK,
		EX_BLOCK,
		DONE
	} state_e;


	state_e current_state;
	state_e next_state;
	
	always_ff @(posedge clk or negedge rst_n) begin
		if (!rst_n) current_state 	<= INIT;
		else current_state 			<= next_state;
	end

	always_comb begin
		case (current_state)
		// INIT: begin
		// 	if (start) 	next_state = START;
		// 	else 			next_state = INIT;
		// 	valid 		= 0; 
		// 	nxt_block 	= 0; 
		// 	en_vsx 		= 0; 
		// 	en_counter 	= 0; 
		// 	ready 		= 0;
		// 	read_data_fifo = 0;
		// end
		INIT: begin
			if (start) 	next_state = PREPARE_DATA;
			else 			next_state = INIT;
			valid 		= 0; 
			nxt_block 	= 0; 
			en_vsx 		= 0; 
			en_counter 	= 0; 
			ready 		= 0;
			read_data_fifo = 0;
		end
		PREPARE_DATA: begin 
			next_state = START;
			valid 		= 0; 
			nxt_block 	= 0; 
			en_vsx 		= 0; 
			en_counter 	= 0; 
			ready 		= 0;
			read_data_fifo = 1;
		end
		START: begin
			if (last) 	next_state = FULL_DATA;
			else 			next_state = WAIT_DATA;	
			valid 		= 1; 
			nxt_block 	= 0; 
			en_vsx 		= 0; 
			en_counter 	= 0; 
			ready 		= 0;
			read_data_fifo = 1;
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
			read_data_fifo = 0;
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
			read_data_fifo = 1;
		end
		EX_FIRST_BLOCK: begin
			if (finish) next_state = DONE;
			else 			next_state = EX_FIRST_BLOCK;
			valid 		= 0; 
			nxt_block 	= 0; 
			en_vsx 		= 1; 
			en_counter 	= 1; 
			ready 		= 0;
			read_data_fifo = 0;
		end
		EX_BLOCK: begin
			if (finish) next_state = DONE;
			else 			next_state = EX_BLOCK;
			valid 		= 0; 
			nxt_block 	= 1; 
			en_vsx 		= 1; 
			en_counter 	= 1; 
			ready 		= 0;
			read_data_fifo = 0;
		end
		DONE: begin
			next_state 	= DONE;
			valid 		= 0; 
			nxt_block 	= 0; 
			en_vsx 		= 0; 
			en_counter 	= 0; 
			ready 		= 1;
			read_data_fifo = 0;
		end
	default: begin
		next_state 	= INIT;
		valid 		= 0; 
		nxt_block 	= 0; 
		en_vsx 		= 0; 
		en_counter 	= 0; 
		ready 		= 0;
		read_data_fifo = 0;
		end
	endcase
	end
	
endmodule


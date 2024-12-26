import keccak_pkg::plane;
import keccak_pkg::state;
import keccak_pkg::N;

module round_tb();
logic clk;
logic reset_n;
state A_in;
logic en_counter;
state A_out;
logic finish;


logic [4:0] round_num;

round_counter counter(clk, reset_n, en_counter, round_num);
round tr(clk, reset_n, A_in, round_num, A_out, finish);
initial clk = 0;
always #5 clk = !clk;
initial 
begin
reset_n = 0;
A_in = {{64'd0,64'd0,64'd0,64'd0,64'd0},{64'd0,64'd0,64'd0,64'h8000000000000000,64'd0},{64'd0,64'd0,64'd0,64'd0,64'd0},{64'd0,64'd0,64'd0,64'd0,64'd0},{64'd0,64'd0,64'd6,64'd0,64'd0}};
en_counter = 1;
#7;
reset_n = 1; 
#1000;
$stop;
end
endmodule

import keccak_pkg::plane;
import keccak_pkg::state;
import keccak_pkg::N;

module step_mapping (
	input  state         A_in  ,
   input  logic [4:0]   rc_num,
	output state         A_out 
);

   state A_theta ;
   state A_rho   ;
   state A_pi    ;
   state A_chi   ;

   theta theta_inst (
      .A_in    (A_in),    
      .A_out   (A_theta)
   );
   
   rho rho_inst (
      .A_in    (A_theta), 
      .A_out   (A_rho)
   );
   
   pi pi_inst (
      .A_in    (A_rho),   
      .A_out   (A_pi)
   );
   
   chi chi_inst (
      .A_in    (A_pi),    
      .A_out   (A_chi)
   );
   
   iota iota_inst(
      .A_in    (A_chi),   
      .A_out   (A_out), 
      .rc_num  (rc_num)
   );

endmodule
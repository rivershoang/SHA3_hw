module mux (
   input  logic [1599:0] a,
   input  logic [1599:0] b,
   input  logic          sel,
   output logic [1599:0] c
);

   assign c = sel ? a : b;

endmodule 
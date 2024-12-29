module serial_to_paralell_pad (
   input  logic            clk         ,
   input  logic            reset_n     , 

   input  logic            is_last_data,
   input  logic            vld         ,
   input  logic            enable_count,
   input  logic [ 63: 0]   data_in     , 

   output logic [1087:0]   data_out    ,
   output logic            is_full     , // 1: full data =136 bytes data
   output logic            is_first_data // 1: first block data
);

//    integer cnt;
//    logic [3:0] block_f;
//    logic [7:0] reg_array [0:135]; // 136 bytes 8-bit for SHA3-256

//    //
//    always_ff @(posedge clk or negedge reset_n) begin 
//       if (~reset_n) begin 
//          is_full        <= 0;
//          cnt             = 0;
//          block_f         = 0; 
//          is_first_data  <= 1;
//          for (int i = 0; i < 136; i = i + 1) begin
//             reg_array[i] <= 0;
//          end
//       end else begin
//          if (is_full && ~enable_count) begin 
//             is_full  <= 0;
//             cnt       = 0;
//          end
//          if (enable_count && (cnt == 0)) for (int i = 0; i < 136; i = i + 1) reg_array[i] <= 0;

//          if (vld && ~is_full) begin 
//             reg_array[cnt]       <= data_in[63:56];
//             reg_array[cnt + 1]   <= data_in[55:48];
//             reg_array[cnt + 2]   <= data_in[47:40];
//             reg_array[cnt + 3]   <= data_in[39:32];
//             reg_array[cnt + 4]   <= data_in[31:24];
//             reg_array[cnt + 5]   <= data_in[23:16];
//             reg_array[cnt + 6]   <= data_in[15: 8];
//             reg_array[cnt + 7]   <= data_in[ 7: 0];
//             cnt                   = cnt + 8;
//             // full data
//             if (cnt == 136) begin 
//                is_full <= 1;
//                block_f  = block_f + 1; 
//             end
//             if (is_last_data) begin 
//                reg_array[cnt] <= 8'h06; // padding
//                reg_array[135] <= 8'h80; // padding
//                is_full        <= 1;
//                cnt             = 0;
//                block_f         = block_f + 1;
//             end
//             if (block_f == 1) is_first_data <= 1;
//             else              is_first_data <= 0;
//          end
//       end
//    end

//    // data out 
//    always_comb begin
//       data_out[63:0]      =	{reg_array[7], reg_array[6], reg_array[5], reg_array[4], reg_array[3], reg_array[2], reg_array[1], reg_array[0]}; 
// 	   data_out[127:64]    =	{reg_array[15], reg_array[14], reg_array[13], reg_array[12], reg_array[11], reg_array[10], reg_array[9], reg_array[8]}; 
// 	   data_out[191:128]   = 	{reg_array[23], reg_array[22], reg_array[21], reg_array[20], reg_array[19], reg_array[18], reg_array[17], reg_array[16]};
// 	   data_out[255:192]   =	{reg_array[31], reg_array[30], reg_array[29], reg_array[28], reg_array[27], reg_array[26], reg_array[25], reg_array[24]};
// 	   data_out[319:256]   =	{reg_array[39], reg_array[38], reg_array[37], reg_array[36], reg_array[35], reg_array[34], reg_array[33], reg_array[32]};
// 	   data_out[383:320]   =	{reg_array[47], reg_array[46], reg_array[45], reg_array[44], reg_array[43], reg_array[42], reg_array[41], reg_array[40]};
// 	   data_out[447:384]   =	{reg_array[55], reg_array[54], reg_array[53], reg_array[52], reg_array[51], reg_array[50], reg_array[49], reg_array[48]};
// 	   data_out[511:448]   =	{reg_array[63], reg_array[62], reg_array[61], reg_array[60], reg_array[59], reg_array[58], reg_array[57], reg_array[56]};
// 	   data_out[575:512]   =	{reg_array[71], reg_array[70], reg_array[69], reg_array[68], reg_array[67], reg_array[66], reg_array[65], reg_array[64]};
// 	   data_out[639:576]   =	{reg_array[79], reg_array[78], reg_array[77], reg_array[76], reg_array[75], reg_array[74], reg_array[73], reg_array[72]};
// 	   data_out[703:640]   =	{reg_array[87], reg_array[86], reg_array[85], reg_array[84], reg_array[83], reg_array[82], reg_array[81], reg_array[80]}; 
// 	   data_out[767:704]   =	{reg_array[95], reg_array[94], reg_array[93], reg_array[92], reg_array[91], reg_array[90], reg_array[89], reg_array[88]}; 
// 	   data_out[831:768]   =	{reg_array[103], reg_array[102], reg_array[101], reg_array[100], reg_array[99], reg_array[98], reg_array[97], reg_array[96]}; 
// 	   data_out[895:832]   =	{reg_array[111], reg_array[110], reg_array[109], reg_array[108], reg_array[107], reg_array[106], reg_array[105], reg_array[104]}; 
// 	   data_out[959:896]   =	{reg_array[119], reg_array[118], reg_array[117], reg_array[116], reg_array[115], reg_array[114], reg_array[113], reg_array[112]}; 
// 	   data_out[1023:960]  =	{reg_array[127], reg_array[126], reg_array[125], reg_array[124], reg_array[123], reg_array[122], reg_array[121], reg_array[120]}; 
// 	   data_out[1087:1024] =	{reg_array[135], reg_array[134], reg_array[133], reg_array[132], reg_array[131], reg_array[130], reg_array[129], reg_array[128]};   
//    end

// endmodule

   logic [7:0] mem [0:167];
   logic	[3:0] first_block;
   integer 	counter;
   integer i;

   always_ff @(posedge clk or negedge reset_n) begin
      if (!reset_n) 	begin	
         is_full <= 0; 
         counter = 0; 
         first_block = 0;
         is_first_data <= 1;
         for (i = 0; i <= 167; i++) mem[i] <= 0;
      end else begin	
         if (is_full && !enable_count) begin 
            is_full <= 0; 
            counter = 0; 
         end	

         if (enable_count && counter == 0) for (i = 0; i <= 167; i++) mem[i] <= 0; 
         if (vld && !is_full) begin
            mem[counter]  	   <= data_in[63:56];
            mem[counter+1]    <= data_in[55:48];
            mem[counter+2]    <= data_in[47:40];
            mem[counter+3]	   <= data_in[39:32];
            mem[counter+4]    <= data_in[31:24];
            mem[counter+5]    <= data_in[23:16];
            mem[counter+6]    <= data_in[15:8];
            mem[counter+7]	   <= data_in[7:0];
            counter = counter + 8; 
            if (136 == counter) begin 
               is_full <= 1; 
               first_block = first_block + 1; 
            end 
            if (is_last_data) begin
               mem[counter]   <= 8'h06;	
               mem[135]       <= 8'h80; 
               is_full        <= 1; 
               counter        = 0;
               first_block    = first_block + 1;
            end
            if (first_block == 1)   is_first_data <= 1; 
            else                    is_first_data <= 0;
         end
      end
   end

   always_comb begin
      data_out[63:0]      =	{mem[7], mem[6], mem[5], mem[4], mem[3], mem[2], mem[1], mem[0]}; 
      data_out[127:64]    =	{mem[15], mem[14], mem[13], mem[12], mem[11], mem[10], mem[9], mem[8]}; 
      data_out[191:128]   = 	{mem[23], mem[22], mem[21], mem[20], mem[19], mem[18], mem[17], mem[16]};
      data_out[255:192]   =	{mem[31], mem[30], mem[29], mem[28], mem[27], mem[26], mem[25], mem[24]};
      data_out[319:256]   =	{mem[39], mem[38], mem[37], mem[36], mem[35], mem[34], mem[33], mem[32]};
      data_out[383:320]   =	{mem[47], mem[46], mem[45], mem[44], mem[43], mem[42], mem[41], mem[40]};
      data_out[447:384]   =	{mem[55], mem[54], mem[53], mem[52], mem[51], mem[50], mem[49], mem[48]};
      data_out[511:448]   =	{mem[63], mem[62], mem[61], mem[60], mem[59], mem[58], mem[57], mem[56]};
      data_out[575:512]   =	{mem[71], mem[70], mem[69], mem[68], mem[67], mem[66], mem[65], mem[64]};
      data_out[639:576]   =	{mem[79], mem[78], mem[77], mem[76], mem[75], mem[74], mem[73], mem[72]};
      data_out[703:640]   =	{mem[87], mem[86], mem[85], mem[84], mem[83], mem[82], mem[81], mem[80]}; 
      data_out[767:704]   =	{mem[95], mem[94], mem[93], mem[92], mem[91], mem[90], mem[89], mem[88]}; 
      data_out[831:768]   =	{mem[103], mem[102], mem[101], mem[100], mem[99], mem[98], mem[97], mem[96]}; 
      data_out[895:832]   =	{mem[111], mem[110], mem[109], mem[108], mem[107], mem[106], mem[105], mem[104]}; 
      data_out[959:896]   =	{mem[119], mem[118], mem[117], mem[116], mem[115], mem[114], mem[113], mem[112]}; 
      data_out[1023:960]  =	{mem[127], mem[126], mem[125], mem[124], mem[123], mem[122], mem[121], mem[120]}; 
      data_out[1087:1024] =	{mem[135], mem[134], mem[133], mem[132], mem[131], mem[130], mem[129], mem[128]}; 
   end
    
endmodule

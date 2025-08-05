module Main_DSP(A,B,C,D,CARRYIN,out_M,P,
	CARRYOUT,CARRYOUTF,CLK,opmode,
CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,
RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP,BCIN,
BCOUT,PCOUT,PCIN);


parameter A0REG=0;
parameter A1REG=1;
parameter B0REG=0;
parameter B1REG=1;
parameter CREG=1; 
parameter DREG=1;
parameter MREG=1; 
parameter PREG=1;
parameter CARRYINREG=1; 
parameter CARRYOUTREG=1; 
parameter OPMODEREG=1;
parameter CARRYINSEL="OPMODE5"; // or 'CARRYIN'
parameter B_INPUT="DIRECT"; // or 'CASCADE' which is from the BCIN
parameter RSTTYPE="SYNC"; // or 'ASYNC'


input wire [17:0] A,B,D;
input wire [47:0] C;
reg [17:0] A0_REG,A1_REG,B0_REG,B1_REG,D_REG;
reg [35:0]M_REG;
reg [47:0] C_REG;
reg CYO,CYI;
reg [47:0] P_REG;
input wire CARRYIN;
output wire [35:0]out_M; //will be sign extended

output wire [47:0]P;
output wire CARRYOUTF,CARRYOUT;

input CLK;
input wire [7:0]opmode;
reg [7:0]opmode_REG;
input CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP;
input RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP;

output wire [17:0]BCOUT;
output wire [47:0]PCOUT;
input wire [47:0]PCIN;
input wire [17:0]BCIN;
wire [17:0]W_D,W_B_INPUT_MUX,W_B0,W_A0,W_PRE_AS,W_bet_mux_B1,W_B1_bef_mult,W_A1_bef_mult;

wire [47:0]W_C,W_DAB_CONC,W_Z_MUX,W_X_MUX,W_POST_AS,W_M_signed;
 wire [7:0]W_opmode;
wire [35:0]W_after_mult;

wire W_CARRYIN,W_CARRYOUT,W_bef_CYI;



 	if (RSTTYPE == "SYNC") begin
 		// Flip flops with clocks
always @(posedge CLK  ) begin

		if ((RSTA == 1) && (CEA==1)) begin
			A0_REG<=0;
		end

else if ((RSTA == 0) && (CEA==1))begin
	A0_REG<= A;
end
	end

always @(posedge CLK ) begin

		if ((RSTA == 1) && (CEA==1))begin
			A1_REG<=0;
		end

else if ((RSTA == 0) && (CEA==1)) begin
	A1_REG<=W_A0;
end
	end

always @(posedge CLK ) begin

		if ((RSTB == 1) && (CEB==1)) begin
			B0_REG<=0;
		end

else if  ((RSTB == 0) && (CEB==1))begin
	B0_REG<=W_B_INPUT_MUX;
end
	end


always @(posedge CLK  ) begin

		if ((RSTB == 1) && (CEB==1)) begin
			B1_REG<=0;
		end

else if ((RSTB == 0) && (CEB==1)) begin
	B1_REG<=W_bet_mux_B1;
end
	end


always @(posedge CLK  ) begin

		if  ((RSTD == 1) && (CED==1))begin
			D_REG<=0;
			
		end

else if((RSTD == 0) && (CED==1))begin
	D_REG<=D;
	
end
end

always @(posedge CLK ) begin

		if ((RSTC == 1) && (CEC==1)) begin
			C_REG<=0;
			
		end

else if((RSTC == 0) && (CEC==1))begin
	C_REG<=C;
	
end

end
always @(posedge CLK ) begin

		if  ((RSTOPMODE == 1) && (CEOPMODE==1))begin
			opmode_REG<=0;
			
		end

else if((RSTOPMODE == 0) && (CEOPMODE==1))begin
	opmode_REG<=opmode;
	
end
end
always @(posedge CLK  ) begin

		if ((RSTM == 1) && (CEM==1))begin
			M_REG<=0;
			
		end

else if((RSTM == 0) && (CEM==1))begin
	M_REG<=W_after_mult;
	
end
end
always @(posedge CLK ) begin

		if ((RSTP == 1) && (CEP==1))begin
			P_REG<=0;
			
		end

else if((RSTP == 0) && (CEP==1))begin
	P_REG<=W_POST_AS;
	
end

end
always @(posedge CLK or posedge CECARRYIN ) begin

		if ((RSTCARRYIN == 1) && (CECARRYIN==1)) begin
			CYI<=0;
			CYO<=0;
			
		end

else if((RSTCARRYIN == 0) && (CECARRYIN==1))begin
	CYI<=W_bef_CYI;
	CYO<=W_CARRYOUT;
	
end

 	end
end

  if(RSTTYPE == "ASYNC") begin
 		// Flip flops with clocks
always @(posedge CLK or posedge RSTA) begin

		if (RSTA == 1) begin
			A0_REG<=0;
		end

else if ((RSTA == 0) && (CEA==1))begin
	A0_REG<=A;
end
	end

always @(posedge CLK or posedge RSTA) begin

		if (RSTA == 1) begin
			A1_REG<=0;
		end

else if ((RSTA == 0) && (CEA==1))begin
	A1_REG<=W_A0;
end
	end

always @( posedge CLK or posedge RSTB) begin

		if (RSTB == 1) begin
			B0_REG<=0;
		end

else if ((RSTB == 0) && (CEB==1))begin
	B0_REG<=W_B_INPUT_MUX;
end
	end


always @( posedge CLK or posedge RSTB) begin

		if (RSTB == 1) begin
			B1_REG<=0;
		end

else if ((RSTB == 0) && (CEB==1))begin
	B1_REG<=W_bet_mux_B1;
end
	end


always @(posedge CLK or posedge RSTD) begin

		if (RSTD == 1) begin
			D_REG<=0;
			
		end

else if ((RSTD == 0) && (CED==1))begin
	D_REG<=D;
	
end

end
always @(posedge CLK or posedge RSTC) begin

		if (RSTC == 1) begin
			C_REG<=0;
			
		end

else if ((RSTC == 0) && (CEC==1))begin
	C_REG<=C;
	
end
end
always @(posedge CLK or posedge RSTOPMODE) begin

		if (RSTOPMODE == 1) begin
			opmode_REG<=0;
			
		end

else if ((RSTOPMODE == 0) && (CEOPMODE==1))begin
	opmode_REG<=opmode;
	
end
end
always @(posedge CLK or posedge RSTM ) begin

		if (RSTM == 1) begin
			M_REG<=0;
			
		end

else if ((RSTM == 0) && (CEM==1))begin
	M_REG<=W_after_mult;
	
end
end
always @(posedge CLK or posedge RSTP) begin

		if (RSTP == 1) begin
			P_REG<=0;
			
		end

else if ((RSTP == 0) && (CEP==1))begin
	P_REG<=W_POST_AS;
	
end

end
always @(posedge CLK or posedge RSTCARRYIN) begin

		if (RSTCARRYIN == 1) begin
			CYI<=0;
			CYO<=0;
			
		end

else if ((RSTCARRYIN == 0) && (CECARRYIN==1))begin
	CYI<=W_bef_CYI;
	CYO<=W_CARRYOUT;
	
end

 	end

end
//Assignes of Combinitional

if (B_INPUT == "DIRECT") begin
		assign W_B_INPUT_MUX=B;
	end
	else if(B_INPUT == "CASCADE") begin
		assign W_B_INPUT_MUX=BCIN;
	end
	else begin
		assign W_B_INPUT_MUX=0;
	end


assign W_D = DREG?D_REG:D;
assign W_B0 = B0REG?B0_REG:W_B_INPUT_MUX;
assign W_A0 = A0REG?A0_REG:A ;
assign W_C = CREG?C_REG:C ;
assign W_opmode = OPMODEREG?opmode_REG:opmode;

assign W_PRE_AS =W_opmode[6] ? (W_D - W_B0):(W_D + W_B0) ;

assign W_bet_mux_B1 =W_opmode[4]?W_PRE_AS:W_B0 ;
assign W_B1_bef_mult =B1REG?B1_REG:W_bet_mux_B1 ;
assign W_A1_bef_mult =A1REG?A1_REG:W_A0;
assign W_after_mult = W_A1_bef_mult *  W_B1_bef_mult;
assign W_DAB_CONC = {D[11:0],A,W_B1_bef_mult} ;
assign out_M =MREG?M_REG: W_after_mult;

assign W_M_signed ={{48-36{out_M[36-1]}}, out_M} ;
assign BCOUT =W_B1_bef_mult ;


	
	reg [47:0]W_X_MUX_R ;
always @(*)
begin
    case(opmode_REG[1:0])
        2'b00: W_X_MUX_R = 0; // When opmode_REG is 00
        2'b01: W_X_MUX_R = W_M_signed; // When opmode_REG is 01
        2'b10: W_X_MUX_R = PCOUT; // When opmode_REG is 10
        2'b11: W_X_MUX_R = W_DAB_CONC; // When opmode_REG is 11
  
    endcase
end

assign W_X_MUX = W_X_MUX_R;

reg [47:0]W_Z_MUX_R ;
always @(*)
begin
    case(opmode_REG[3:2])
        2'b00: W_Z_MUX_R = 0; // When opmode_REG is 00
        2'b01: W_Z_MUX_R = PCIN; // When opmode_REG is 01
        2'b10: W_Z_MUX_R = PCOUT; // When opmode_REG is 10
        2'b11: W_Z_MUX_R = W_C; // When opmode_REG is 11
  
    endcase
end

assign W_Z_MUX = W_Z_MUX_R;


if(CARRYINSEL == "OPMODE5") begin
	assign W_bef_CYI = W_opmode[5];
end
else if (CARRYINSEL == "CARRYIN") begin
	assign W_bef_CYI = CARRYIN;
end

else begin
	assign W_bef_CYI = 0;
end

assign W_CARRYIN = CARRYINREG? CYI :W_bef_CYI ;

assign {W_CARRYOUT,W_POST_AS}= W_opmode[7]? (W_Z_MUX - (W_CARRYIN + W_X_MUX)):(W_X_MUX+W_Z_MUX) ;
assign CARRYOUT = CARRYOUTREG?CYO:W_CARRYOUT;
assign CARRYOUTF = CARRYOUT;

assign P =PREG? P_REG: W_POST_AS;
assign PCOUT =P;
 

endmodule 
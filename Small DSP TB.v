module Small_DSP_TB();
 reg[17:0]A_TB_1,B_TB_1,D_TB_1,A_TB_2,B_TB_2,D_TB_2;
 reg[47:0]C_TB_1,C_TB_2;
 wire [47:0] P_DUT_1,P_DUT_2;
 reg [47:0] P_EXP;
 reg CLK_TB,rst_n_TB;
 parameter OP_ADD="ADD";
 parameter OP_SUB="SUBTRACT";
 
Small_DSP #(OP_ADD) DUT_ADD(A_TB_1,B_TB_1,C_TB_1,D_TB_1,P_DUT_1,CLK_TB,rst_n_TB);
Small_DSP #(OP_SUB) DUT_SUB(A_TB_2,B_TB_2,C_TB_2,D_TB_2,P_DUT_2,CLK_TB,rst_n_TB);


initial begin
	CLK_TB=0;
	forever 
	#1 CLK_TB=~CLK_TB;
end

initial begin
	rst_n_TB=1;
	forever 
	#40 rst_n_TB=~rst_n_TB;
end


initial begin
#0
rst_n_TB=0;
P_EXP=0;
#10
	if (P_DUT_1 != P_EXP) begin
		$display("Error");
		$stop;
	end




	#10
rst_n_TB=1;
	A_TB_1=18'hA;
	B_TB_1=18'hB;
	C_TB_1=48'hC;
	D_TB_1=18'hD;

	P_EXP=(C_TB_1+((A_TB_1)*(D_TB_1+B_TB_1)));
	#10
	if (P_DUT_1 != P_EXP) begin
		$display("Error");
		$stop;
	end


	#10
rst_n_TB=1;
	A_TB_1=18'hA7;
	B_TB_1=18'hB6;
	C_TB_1=48'hC7;
	D_TB_1=18'hD6;

	P_EXP=(C_TB_1+((A_TB_1)*(D_TB_1+B_TB_1)));
	#10
	if (P_DUT_1 != P_EXP) begin
		$display("Error");
		$stop;
	end

	
	#10
rst_n_TB=1;
	A_TB_2=18'hA;
	B_TB_2=18'h1;
	C_TB_2=48'h1111;
	D_TB_2=18'hDD;
	P_EXP=(((A_TB_2) * (D_TB_2-B_TB_2))-C_TB_2);
	#10
	if (P_DUT_2 != P_EXP) begin
		$display("Error");
		$stop;
	end

#10
rst_n_TB=1;
	A_TB_2=18'h5;
	B_TB_2=18'hA;
	C_TB_2=48'h1111;
	D_TB_2=18'hB6;
	P_EXP=(((A_TB_2) * (D_TB_2-B_TB_2))-C_TB_2);
	#10
	if (P_DUT_2 != P_EXP) begin
		$display("Error");
		$stop;
	end

end


initial begin
	$monitor("A_add=%h,B_add=%h,C_add=%h,D_add=%h,P_add=%h",A_TB_1,B_TB_1,C_TB_1,D_TB_1,P_EXP);
end
initial begin
	$monitor("A_sub=%h,B_sub=%h,C_sub=%h,D_sub=%h,P_sub=%h",A_TB_2,B_TB_2,C_TB_2,D_TB_2,P_EXP);
end

endmodule






















/*#10
rst_n_TB=1;
	A_TB_1=18'h5;
	B_TB_1=18'h5632;
	C_TB_1=48'hAABB;
	D_TB_1=18'hBC98;

	P_EXP=48'h608AD;
	#10
	if (P_DUT_1 != P_EXP) begin
		$display("Error");
		$stop;
	end


	#10
rst_n_TB=1;
	A_TB_1=18'h4;
	B_TB_1=18'h2548;
	C_TB_1=48'hEFCD;
	D_TB_1=18'hBA77;

	P_EXP=48'h46EC9;
	#10
	if (P_DUT_1 != P_EXP) begin
		$display("Error");
		$stop;
	end



#10
rst_n_TB=1;
	A_TB_2=18'h3;
	B_TB_2=18'h5555;
	C_TB_2=48'hDF82;
	D_TB_2=18'hFFFF;

	P_EXP=48'h1207C;
	#10
	if (P_DUT_2 != P_EXP) begin
		$display("Error");
		$stop;
	end

#10

	A_TB_2=18'h6;
	B_TB_2=18'h6666;
	C_TB_2=48'hABCD;
	D_TB_2=18'hEEEE;

	P_EXP=48'h28763;
	#10
	if (P_DUT_2 != P_EXP) begin
		$display("Error");
		$stop;
	end

end*/
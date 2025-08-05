module Small_DSP(A,B,C,D,P,CLK,rst_n);
input wire[17:0]A,B,D;
input wire[47:0]C;
input CLK,rst_n;
output wire [47:0] P;
reg [47:0] P_REG;
reg [17:0] A_REG;
reg [47:0] C_REG;
reg [17:0] D_REG;
reg [17:0] B_REG;

reg [17:0] first_adder;
reg [35:0] multiplier;

wire [17:0] After_D_REG,After_B_REG,After_A_REG,before_multiplier;
wire [47:0] After_C_REG;
wire [47:0] before_second_adder;

assign After_A_REG = A_REG ;
assign After_B_REG = B_REG ;
assign After_C_REG = C_REG ;
assign After_D_REG = D_REG ;


parameter OPERATION ="ADD";



always @(posedge CLK ) begin
	if (rst_n == 0) begin
		D_REG<=0;
		C_REG<=0;
		B_REG<=0;
		A_REG<=0;
	end

	else if(rst_n == 1) begin
		
		D_REG<=D;
		C_REG<=C;
		B_REG<=B;
		A_REG<=A;
	end
end

always @(posedge CLK ) begin
	if (rst_n == 0) begin
		multiplier<=0;
		
	end

	else if(rst_n == 1) begin
		
		multiplier<= (After_A_REG * before_multiplier);
	end
end
assign before_second_adder =multiplier ;


always @(posedge CLK ) begin
	if (rst_n == 0) begin
		first_adder<=0;
		
	end

	else if(rst_n == 1) begin
		
		if (OPERATION == "ADD") begin
			first_adder<= (After_D_REG+After_B_REG);
		end
		else if(OPERATION == "SUBTRACT") begin
			first_adder<= (After_D_REG-After_B_REG);
		end
	end
end
assign before_multiplier = first_adder ;

always @(posedge CLK ) begin
	if (rst_n == 0) begin
		P_REG<=0;
		
	end

	else if(rst_n == 1) begin
		
		if (OPERATION == "ADD") begin
			P_REG<= (before_second_adder + After_C_REG);
		end
		else if(OPERATION == "SUBTRACT") begin
			P_REG<= (before_second_adder - After_C_REG);
		end
		end

end

assign P =P_REG ;


endmodule
`timescale 1ns/1ns

module TB ();

    // Parameteres
    localparam LENGTH = 64;
    localparam WIDTH = 16;
    localparam WIDTH_o = WIDTH * 2 + $clog2(LENGTH);
    localparam COUNTER_BIT = $clog2(LENGTH) - 1;
    parameter DATA_LEN = 5;

    reg [WIDTH_o-1:0]  expected_data [0:DATA_LEN];
    reg [WIDTH-1:0]  input_data [0:DATA_LEN];
    reg [WIDTH_o-1:0]  temp_out;

    // Needed wires
    reg clk;
    reg rst;
    reg input_valid;
    reg [WIDTH - 1 : 0] FIR_input;
    wire output_valid;
    wire [WIDTH_o - 1 : 0] FIR_output;

    integer cnt, i, fp;

    FIR_filter #(
        .LENGTH(LENGTH),
        .WIDTH(WIDTH),
        .COUNTER_BIT(COUNTER_BIT),
        .WIDTH_o(WIDTH_o)
    ) fir (
        .clk(clk),
        .rst(rst),
        .valid_Input(input_valid),
        .FIR_input(FIR_input),
        .Output_valid(output_valid),
        .FIR_output(FIR_output)
    );
    // Reading from files
    initial begin  
        $readmemb("inputs.txt", input_data);   
    end

    initial begin
        $readmemb("outputs.txt", expected_data);
    end     

    initial begin
      clk = 1'b0;
    end

    always #10 clk = ~clk;

    initial begin 
        //Reseting
        input_valid = 1'b0;
        rst = 1'b0;
        FIR_input = 16'b0;   
        cnt = 0;
        #100;
        rst = 1'b1;
        #100;
        rst = 1'b0;
    end     

initial begin
	fp = $fopen("outManualFIRVerilog.txt");
	#400;
    
	$display("Testing %d Samples...",DATA_LEN);		
	for(i = 0; i < DATA_LEN; i = i + 1)
	begin
		@(posedge clk)
		begin
			FIR_input = input_data[i];
            input_valid = 1'b1;
            @(posedge clk)
            input_valid = 1'b0;
		
            @(posedge output_valid)
			begin
					$fwrite(fp,"%b\n",FIR_output);
					temp_out = expected_data[i];
					if(FIR_output != temp_out[WIDTH_o - 1:0])
					    $display("test failed: %d   input: %x expected: %x output: %x" , i, FIR_input, temp_out[WIDTH_o-1:0], FIR_output);
                    else
                        $display("test passed: %d   input: %x expected: %x output: %x" , i, FIR_input, temp_out[WIDTH_o-1:0], FIR_output);

			end

		end
	end
$fclose(fp);
$finish;
end

   

endmodule
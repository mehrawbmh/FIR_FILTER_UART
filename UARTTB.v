module UARTTB();
    reg clk;
    reg from_computer;
    wire to_computer;
    reg rst;
    
    wire reset_out = rst;

    TopModule dut(
    .clk(clk),
    .rst(rst),
    .from_computer(from_computer),
    .to_computer(to_computer)
    );

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        from_computer = 1'b1;
        #100
        rst = 1'b1;
        #100
        rst = 1'b0;
    end

    always #10 clk = ~clk; //50MHz
    //00000001 00100101
    initial begin
        #300
        from_computer = 1'b0; //start bit - MSB
        #8700
        from_computer = 1'b1;
        #8700
        from_computer = 1'b0;
        #8700
        from_computer = 1'b0;
        #8700
        from_computer = 1'b0;
        #8700
        from_computer = 1'b0;
        #8700
        from_computer = 1'b0;
        #8700
        from_computer = 1'b0;
        #8700
        from_computer = 1'b0;
        #8700
        from_computer = 1'b1; //stop bit - MSB
        #50000 
        from_computer = 1'b0; //start bit - LSB
        #8700
        from_computer = 1'b1;
        #8700
        from_computer = 1'b0;
        #8700
        from_computer = 1'b1;
        #8700
        from_computer = 1'b0;
        #8700
        from_computer = 1'b0;
        #8700
        from_computer = 1'b1;
        #8700
        from_computer = 1'b0;
        #8700
        from_computer = 1'b0;
        #8700
        from_computer = 1'b1; //stop bit - LSB
        #200000
        

        $stop;
    end

endmodule

`timescale  1ns/1ns
module tranmitterTB();
    reg clk, start;
    reg [7:0] data;

    wire out, busy;

    async_transmitter aa(clk, start, data, out, busy);

    initial begin
        clk = 1'b0;
        start = 1'b0;
        data = 8'd0;
    end

    always #10 clk = ~clk; //50MHz

    initial begin
        #50
        data = 8'b01001100;
        #30 start = 1'b1;

        #100000
        data = 8'd100;
        #100000
        $stop;
    end


endmodule

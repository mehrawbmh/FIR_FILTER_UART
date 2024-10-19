`timescale  1ns/1ns
module receiverTB();
    reg clk, start;
    wire [7:0] data;

    wire out, ready;

    reg rxd;

    async_receiver ar(clk, rxd, ready, data);

    initial begin
        clk = 1'b0;
        rxd = 1'b1;
    end

    always #10 clk = ~clk; //50MHz

    //10010110
    initial begin
        #50
        rxd = 1'b0;
        #8700
        rxd = 1'b1;
        #8700
        rxd = 1'b0;
        #8700
        rxd = 1'b0;
        #8700
        rxd = 1'b0;
        #8700
        rxd = 1'b0;
        #8700
        rxd = 1'b0;
        #8700
        rxd = 1'b0;
        #8700
        rxd = 1'b0;
        #8700
        $stop;
    end


endmodule

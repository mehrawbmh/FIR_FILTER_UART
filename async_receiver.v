module async_receiver(
    input clk,
    input RxD,
    input rst,
    output reg RxD_data_ready,
    output reg [7:0] RxD_data
);
    parameter ClkFrequency = 50000000;
    parameter Baud = 115200;
    parameter Oversampling = 4;

    localparam divideCount = ClkFrequency / (Baud * Oversampling);
    localparam len = $clog2(divideCount);

    wire tick;
    reg tickEn;

    BaudTickGen #(ClkFrequency, Baud, Oversampling) tickgen(.clk(clk), .enable(tickEn), .tick(tick));
    reg [3:0] TxD_state = 0;

    reg[1:0] count;
    reg clear;
    wire cntEn;


    wire co;
    assign co = (count == 2'b10);

    assign RxD_busy = ~RxD_data_ready;

    always @(posedge clk or posedge rst) begin
        if (rst) begin count = 2'b00;end
        else if(clear) begin count = 2'b00; end
        else if (tick && cntEn) begin
            count = count + 1'b1;
        end

    end

    assign cntEn = ~(TxD_state == 4'b0000 && RxD);
	 

    always @(posedge clk or posedge rst) begin
        RxD_data_ready = 1'b0;
        tickEn = 1'b1;
        clear = 1'b0;
		  
        case(TxD_state)
            4'b0000: if(tick) begin TxD_state <= (~RxD) ? 4'b0001 : TxD_state; tickEn = 1'b0; RxD_data=8'b0;end
            4'b0001: if(tick) begin TxD_state <= (count == 2'b11) ? 4'b0010 : TxD_state; end
            4'b0010: if(tick) begin TxD_state <= (count == 2'b11) ? 4'b0011 : TxD_state; if (co) RxD_data[0] = RxD; end  // bit 0
            4'b0011: if(tick) begin TxD_state <= (count == 2'b11) ? 4'b0100 : TxD_state; if (co) RxD_data[1] = RxD; end  // bit 1
            4'b0100: if(tick) begin TxD_state <= (count == 2'b11) ? 4'b0101 : TxD_state; if (co) RxD_data[2] = RxD; end  // bit 2
            4'b0101: if(tick) begin TxD_state <= (count == 2'b11) ? 4'b0110 : TxD_state; if (co) RxD_data[3] = RxD; end  // bit 3
            4'b0110: if(tick) begin TxD_state <= (count == 2'b11) ? 4'b0111 : TxD_state; if (co) RxD_data[4] = RxD; end  // bit 4
            4'b0111: if(tick) begin TxD_state <= (count == 2'b11) ? 4'b1000 : TxD_state; if (co) RxD_data[5] = RxD;  end  // bit 5
            4'b1000: if(tick) begin TxD_state <= (count == 2'b11) ? 4'b1001 : TxD_state; if (co) RxD_data[6] = RxD; end  // bit 6
            4'b1001: if(tick) begin TxD_state <= (count == 2'b11) ? 4'b1010 : TxD_state; if (co) RxD_data[7] = RxD; end  // bit 7
            4'b1010: if(tick) begin TxD_state <= (count == 2'b11) & RxD ? 4'b0000 : TxD_state; if (co) RxD_data_ready = 1'b1; clear = (count == 2'b11) & RxD; end  // stop
            default: TxD_state <= 4'b0000;
        endcase 

    end
endmodule
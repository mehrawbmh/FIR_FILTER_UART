module wrapper_controller(clk, rst, RxD, TxD_busy, RxD_data_ready, ld1, ld2, FIR_input_valid, FIR_output_valid, mode, ldRes, done, reset_fir, TxD_start);
    input clk, rst, RxD, RxD_data_ready, TxD_busy, FIR_output_valid;
    output reg ld1, ld2, ldRes, mode, FIR_input_valid, done, reset_fir, TxD_start;

	reg[3:0] ps, ns;
	localparam[3:0] IDLE = 4'd0,
                    RECEIVE1 = 4'd1, 
                    RECEIVE2 = 4'd2, 
                    START_FIR = 4'd3, 
                    WORK_FIR = 4'd4, 
                    FIFO_RES1 = 4'd5,
                    FIFO_RES2 = 4'd6,
                    TRANSMIT1 = 4'd7,
                    TRANSMIT2 = 4'd8,
                    DONE = 4'd9,
						  WAIT = 4'd10;

	always @(posedge clk, posedge rst) begin
		if (rst) 
			ps <= IDLE;
		else 
			ps <= ns;
	end


	always @(ps, RxD, RxD_data_ready, FIR_output_valid, TxD_busy) begin
		case(ps)
            IDLE:
                ns <= RxD ? IDLE : RECEIVE1;
            RECEIVE1:
                ns <= RxD_data_ready & RxD ? RECEIVE2 : RECEIVE1;
            RECEIVE2:
                ns <= RxD_data_ready & RxD? START_FIR : RECEIVE2;
            START_FIR:
                ns <= WORK_FIR;
            WORK_FIR:
                ns <= FIR_output_valid ? FIFO_RES1 : WORK_FIR;
            FIFO_RES1:
                ns <= TRANSMIT1;
            FIFO_RES2: // ignore
                ns <= TRANSMIT1;
            TRANSMIT1:
                ns <= TxD_busy ? TRANSMIT1 : TRANSMIT2;		 
			WAIT:
				ns <= TRANSMIT2;
            TRANSMIT2:
                ns <= TxD_busy ? TRANSMIT2 : IDLE;
            default:
                ns <= IDLE;
		endcase
	end

	always @(ps, FIR_output_valid, TxD_busy) begin
		{ld1, ld2, ldRes, mode, FIR_input_valid, done, reset_fir, TxD_start} = 8'b00000000;
        
        case(ps)
            RECEIVE1: begin
				ld1 <= 1'b1;
			end

			RECEIVE2: begin 
				ld2 <= 1'b1;
			end
			
            START_FIR: begin
				FIR_input_valid <= 1'b1;
			end
			
            FIFO_RES1: begin
				TxD_start <= 1'b1;
                mode <= 1'b0;
			end
            
            FIFO_RES2: begin
            end

            TRANSMIT1: begin
                mode <= ~TxD_busy;
				TxD_start <= 1'b1;
            end
			
			WAIT:begin
                 mode <= 1'b1;
            end

		   TRANSMIT2: begin
                mode <= 1'b1;
                TxD_start <= 1'b1;
            end
		endcase	
	end

endmodule

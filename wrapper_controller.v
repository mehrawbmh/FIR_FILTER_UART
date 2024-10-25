module wrapper_controller(clk, rst, RxD, TxD_busy, RxD_data_ready, ld1, ld2, FIR_input_valid, FIR_output_valid, mode, ldRes);
    input clk, rst, RxD, RxD_data_ready, FIR_input_valid, TxD_busy;
    output ld1, ld2, ldRes, mode, FIR_output_valid, done;

	logic[3:0] ps, ns;
	localparam[3:0] IDLE = 3'd0,
                    RECEIVE1 = 3'd1, 
                    RECEIVE2 = 3'd2, 
                    START_FIR = 3'd3, 
                    WORK_FIR = 3'd4, 
                    FIFO_RES1 = 3'd5,
                    FIFO_RES2 = 3'd6
                    TRANSMIT1 = 3'd7,
                    TRANSMIT2 = 3'd8,
                    DONE = 3'd9;

	always @(posedge clk, posedge rst) begin
		if (rst) 
			ps <= IDLE;
		else 
			ps <= ns;
	end


	always @(ps, RxD, RxD_data_ready, FIR_input_valid, TxD_busy) begin
		case(ps)
            IDLE:
                ns <= RxD ? IDLE : RECEIVE1;
            RECEIVE1:
                ns <= RxD_data_ready ? RECEIVE2 : RECEIVE1;
            RECEIVE2:
                ns <= RxD_data_ready ? START_FIR : RECEIVE2;
            START_FIR:
                ns <= WORK_FIR;
            WORK_FIR:
                ns <= FIR_output_valid ? FIFO_RES1 : WORK_FIR;
            FIFO_RES1:
                ns <= FIFO_RES2;
            FIFO_RES2:
                ns <= TRANSMIT1;
            TRANSMIT1:
                ns <= TxD_busy ? TRANSMIT1 : TRANSMIT2;
            TRANSMIT2:
                ns <= TxD_busy ? TRANSMIT2 : DONE;
            DONE:
                ns <= IDLE;
            default:
                ns <= IDLE;
		endcase
	end

	always @(ps) begin
		{ld1, ld2, ldRes, mode, FIR_output_valid, done} = 6'b000000;
        
        case(ps)
            RECEIVE1: begin
				ld1 = 1'b1;
			end

			RECEIVE2: begin 
				ld2 = 1'b1;
			end
			
            START_FIR: begin
				FIR_input_valid = 1'b1;
			end
			
            FIFO_RES1: begin
				ldRes = 1'b1;
                mode = 1'b0;
			end
            
            FIFO_RES2: begin
                ldRes = 1'b1;
                mode = 1'b1;
            end
            
            DONE: begin
				done = 1'b1;
            end
		endcase	
	end

endmodule

module TopModule (
    input clk,
    input rst,
    input  from_computer,
    output to_computer
);
    wire TxD_start, TxD_busy, RxD_data_ready;
    wire load_right, mode_right;
    wire load1_left, load2_left;
    wire FIR_input_valid, FIR_output_valid;
    wire reset_fir;
    wire [7:0] TxD_data, RxD_data;
    wire [15:0] fir_input;
    wire [37:0] fir_output;
    wire debug_done;

    FIR  #(
    .LENGTH(64),
    .WIDTH(16),
    .WIDTH_o(38))
    fir(
    .clk(clk),
    .reset(rst),
    .input_valid(FIR_input_valid),
    .FIR_input(fir_input),
    .output_valid(FIR_output_valid),
    .FIR_output(fir_output)
    );

    async_transmitter transmitter(
    .clk(clk), 
    .TxD_start(TxD_start), 
    .TxD_data(TxD_data), 
    .TxD(to_computer), 
    .TxD_busy(TxD_busy)
    );

    async_receiver receiver(
    .clk(clk), 
    .RxD(from_computer), 
    .RxD_data_ready(RxD_data_ready), 
    .RxD_data(RxD_data),
    .rst(rst)
    );

    Right_FF rff(
    .clk(clk), 
    .load(FIR_output_valid), 
    .mode(mode_right), 
    .in(fir_output), 
    .out(TxD_data)
    );

    Left_FF lff(
    .clk(clk), 
    .load1(load1_left), 
    .load2(load2_left), 
    .in(RxD_data), 
    .out(fir_input)
    );

    wrapper_controller controller(
    .clk(clk), 
    .rst(1'b0), 
    .RxD(from_computer), 
    .RxD_data_ready(RxD_data_ready), 
    .TxD_busy(TxD_busy), 
    .ld1(load1_left),
    .ld2(load2_left),
    .FIR_input_valid(FIR_input_valid),
    .FIR_output_valid(FIR_output_valid),
    .mode(mode_right),
    .ldRes(load_right),
    .done(debug_done),
    .reset_fir(reset_fir),
    .TxD_start(TxD_start)
    );

endmodule
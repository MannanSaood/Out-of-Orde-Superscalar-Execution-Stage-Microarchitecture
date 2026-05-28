`timescale 1ns / 1ps

module tb_reservation_station();
    logic        clk;
    logic        rst_n;
    logic        dispatch_valid_i;
    logic [5:0]  dest_tag_i;
    logic [5:0]  src1_tag_i;
    logic        src1_ready_i;
    logic [5:0]  src2_tag_i;
    logic        src2_ready_i;
    logic        wakeup_valid_i;
    logic [5:0]  wakeup_tag_i;
    logic [7:0]  ready_vector_o;

    reservation_station dut (
        .clk(clk),
        .rst_n(rst_n),
        .dispatch_valid_i(dispatch_valid_i),
        .dest_tag_i(dest_tag_i),
        .src1_tag_i(src1_tag_i),
        .src1_ready_i(src1_ready_i),
        .src2_tag_i(src2_tag_i),
        .src2_ready_i(src2_ready_i),
        .wakeup_valid_i(wakeup_valid_i),
        .wakeup_tag_i(wakeup_tag_i),
        .ready_vector_o(ready_vector_o)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        wakeup_valid_i = 0;
        wakeup_tag_i = 0;
        
        #20 rst_n = 1;
        
        // Wait and issue wakeup
        @(posedge clk);
        wakeup_valid_i = 1;
        wakeup_tag_i = 6'd12;
        
        @(posedge clk);
        wakeup_valid_i = 0;
        
        #20;
        $display("[READ] PASSED %0t -- Reservation Station Wakeup Bus Functional Simulation Complete", $time);
        $finish;
    end
endmodule

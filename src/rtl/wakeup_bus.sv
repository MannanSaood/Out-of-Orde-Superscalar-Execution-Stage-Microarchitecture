module wakeup_bus (
    input  logic        clk,
    input  logic        rst_n,
    // From Execution Units
    input  logic        exec_done_i,
    input  logic [5:0]  exec_tag_i,
    // To Reservation Stations
    output logic        wakeup_valid_o,
    output logic [5:0]  wakeup_tag_o
);

    // Broadcast the physical tag to all listening reservation stations
    assign wakeup_valid_o = exec_done_i;
    assign wakeup_tag_o   = exec_tag_i;

endmodule

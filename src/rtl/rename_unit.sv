module rename_unit (
    input  logic        clk,
    input  logic        rst_n,
    // Dispatch input
    input  logic        dispatch_req_i,
    input  logic  [4:0] dest_arch_i,
    input  logic  [4:0] src1_arch_i,
    input  logic  [4:0] src2_arch_i,
    // Output to Issue Queue
    output logic  [5:0] dest_phys_o,
    output logic  [5:0] src1_phys_o,
    output logic  [5:0] src2_phys_o,
    output logic        dispatch_ack_o,
    // Retirement interface
    input  logic        retire_req_i,
    input  logic  [5:0] retire_phys_i
);

    logic [5:0] free_tag;
    logic       free_valid;
    logic       alloc_req;

    // Pop from Free List when dispatching and a tag is available
    assign alloc_req = dispatch_req_i & free_valid;

    free_list free_list_inst (
        .clk(clk),
        .rst_n(rst_n),
        .pop_req_i(alloc_req),
        .push_req_i(retire_req_i),
        .push_tag_i(retire_phys_i),
        .pop_tag_o(free_tag),
        .valid_o(free_valid),
        .empty_o()
    );

    frat frat_inst (
        .clk(clk),
        .rst_n(rst_n),
        .src1_arch_i(src1_arch_i),
        .src2_arch_i(src2_arch_i),
        .src1_phys_o(src1_phys_o),
        .src2_phys_o(src2_phys_o),
        .alloc_req_i(alloc_req),
        .dest_arch_i(dest_arch_i),
        .alloc_phys_i(free_tag)
    );

    assign dest_phys_o = free_tag;
    assign dispatch_ack_o = alloc_req;

endmodule

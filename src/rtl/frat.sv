module frat (
    input  logic        clk,
    input  logic        rst_n,
    // Read ports for instruction dispatch
    input  logic  [4:0] src1_arch_i,
    input  logic  [4:0] src2_arch_i,
    output logic  [5:0] src1_phys_o,
    output logic  [5:0] src2_phys_o,
    // Write port from Free List allocation
    input  logic        alloc_req_i,
    input  logic  [4:0] dest_arch_i,
    input  logic  [5:0] alloc_phys_i
);

    // 32 architectural registers mapped to 64 physical registers
    logic [5:0] map_table [31:0];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Identity map on reset (r0->p0, r1->p1, etc.)
            for (int i = 0; i < 32; i++) begin
                map_table[i] <= i[5:0];
            end
        end else begin
            if (alloc_req_i) begin
                map_table[dest_arch_i] <= alloc_phys_i;
            end
        end
    end

    assign src1_phys_o = map_table[src1_arch_i];
    assign src2_phys_o = map_table[src2_arch_i];

endmodule

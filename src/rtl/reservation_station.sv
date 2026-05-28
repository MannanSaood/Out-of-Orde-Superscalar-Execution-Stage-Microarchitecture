module reservation_station (
    input  logic        clk,
    input  logic        rst_n,
    // Dispatch Interface
    input  logic        dispatch_valid_i,
    input  logic [5:0]  dest_tag_i,
    input  logic [5:0]  src1_tag_i,
    input  logic        src1_ready_i,
    input  logic [5:0]  src2_tag_i,
    input  logic        src2_ready_i,
    // Wakeup Bus Interface
    input  logic        wakeup_valid_i,
    input  logic [5:0]  wakeup_tag_i,
    // Issue Interface
    output logic [7:0]  ready_vector_o
);

    // 8-entry Unified Reservation Station
    logic [5:0] dest_tags [7:0];
    logic [5:0] src1_tags [7:0];
    logic [5:0] src2_tags [7:0];
    logic       src1_rdy  [7:0];
    logic       src2_rdy  [7:0];
    logic       valid     [7:0];

    // Simplified logic: Just monitoring wakeup for now
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin : gen_rs_entries
            always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    valid[i] <= 1'b0;
                end else begin
                    // Wakeup tag matching
                    if (valid[i] && wakeup_valid_i) begin
                        if (src1_tags[i] == wakeup_tag_i) src1_rdy[i] <= 1'b1;
                        if (src2_tags[i] == wakeup_tag_i) src2_rdy[i] <= 1'b1;
                    end
                end
            end
            
            // Instruction is ready when both sources are ready
            assign ready_vector_o[i] = valid[i] & src1_rdy[i] & src2_rdy[i];
        end
    endgenerate

endmodule

module age_matrix_arbiter #(
    parameter ENTRIES = 8
)(
    input  logic               clk,
    input  logic               rst_n,
    input  logic [ENTRIES-1:0] request_i, // From reservation station ready_vector
    output logic [ENTRIES-1:0] grant_o
);

    // Triangular matrix tracking age dependencies (1 means row is older than col)
    logic [ENTRIES-1:0] age_matrix [ENTRIES-1:0];

    always_comb begin
        grant_o = '0;
        // Simple priority encoder for Phase 2 based on matrix state
        // In a true age matrix, we'd check if a request has no older pending requests
        for (int i = 0; i < ENTRIES; i++) begin
            if (request_i[i]) begin
                grant_o[i] = 1'b1;
                break; // Simplified logic: grant first
            end
        end
    end

endmodule

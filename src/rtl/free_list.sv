module free_list (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        pop_req_i,
    input  logic        push_req_i,
    input  logic  [5:0] push_tag_i,
    output logic  [5:0] pop_tag_o,
    output logic        valid_o,
    output logic        empty_o
);

    // 64-entry FIFO for free physical registers (p0-p63)
    logic [5:0] fifo [63:0];
    logic [5:0] head_ptr, tail_ptr;
    logic [6:0] count;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // On reset, all 64 physical registers are free
            for (int i = 0; i < 64; i++) begin
                fifo[i] <= i;
            end
            head_ptr <= '0;
            tail_ptr <= '0;
            count <= 7'd64;
        end else begin
            if (push_req_i && count < 64) begin
                fifo[tail_ptr] <= push_tag_i;
                tail_ptr <= tail_ptr + 1;
            end
            if (pop_req_i && count > 0) begin
                head_ptr <= head_ptr + 1;
            end

            if (push_req_i && !pop_req_i && count < 64)
                count <= count + 1;
            else if (!push_req_i && pop_req_i && count > 0)
                count <= count - 1;
        end
    end

    assign pop_tag_o = fifo[head_ptr];
    assign valid_o   = (count > 0);
    assign empty_o   = (count == 0);

endmodule

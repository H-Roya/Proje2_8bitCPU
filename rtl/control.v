module control (
    input  wire [3:0] opcode,
    output reg        reg_write,
    output reg        mem_write,
    output reg        alu_src,    
    output reg [3:0]  alu_op,
    output reg        mem_to_reg,
    output reg        jump
);
    always @(*) begin
        reg_write  = 0;
        mem_write  = 0;
        alu_src    = 0;
        alu_op     = 4'b0000;
        mem_to_reg = 0;
        jump       = 0;

        case (opcode)
            4'b0001: begin reg_write = 1; alu_op = 4'b0001; end // ADD
            4'b0010: begin reg_write = 1; alu_op = 4'b0010; end // SUB
            4'b0011: begin reg_write = 1; alu_op = 4'b0011; end // AND
            4'b0100: begin reg_write = 1; alu_op = 4'b0100; end // OR
            4'b0101: begin reg_write = 1; alu_op = 4'b0101; end // NOT
            4'b0110: begin reg_write = 1; alu_src = 1; end      // LI
            4'b0111: begin reg_write = 1; alu_op = 4'b0111; end // LT
            4'b1000: begin reg_write = 1; mem_to_reg = 1; end   // LOAD
            4'b1001: begin mem_write = 1; end                   // STORE
            4'b1010: begin jump = 1; end                        // JUMP
            default: begin end
        endcase
    end
endmodule

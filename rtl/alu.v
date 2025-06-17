module alu (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [3:0] alu_op,
    output reg  [7:0] result,
    output wire       zero
);
    always @(*) begin
        case (alu_op)
            4'b0001: result = a + b;     
            4'b0010: result = a - b;     
            4'b0011: result = a & b;     
            4'b0100: result = a | b;     
            4'b0101: result = ~a;        
            4'b0111: result = (a < b) ? 8'd1 : 8'd0; 
            default: result = 8'd0;
        endcase
    end

    assign zero = (result == 8'd0);

endmodule

module float_adder(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] s
);

reg [7:0] exp_a, exp_b, exp_s;
reg sign_a, sign_b, sign_s;
reg [2:0] now, next;
reg [24:0] mant_a, mant_b, mant_s; // 考虑进位与隐含的1

reg [7:0] diff;
reg [24:0] out;

parameter start = 3'b000, zero = 3'b001, equal = 3'b010, add = 3'b011, norm = 3'b100, done = 3'b101;


always @(posedge clk) begin
    if (!rst) begin
        now <= start;
    end 
    else begin
        now <= next;
    end
end

always @(*) begin
    case(now)
        start:begin
            exp_a<=a[30:23];
            exp_b<=b[30:23];
            mant_a<={1'b0, 1'b1, a[22:0]};
            mant_b<={1'b0, 1'b1, b[22:0]};
            sign_a<=a[31];
            sign_b<=b[31];
            next<= zero;
        end    
        zero:begin
            if(mant_a[22:0]==23'b0 && exp_a == 8'b0) begin
                sign_s<=b[31];
                exp_s<=exp_b;
                mant_s<=mant_b;
                next<=done;
            end
            else if (mant_b[22:0]==23'b0 && exp_b == 8'b0) begin
                sign_s<=a[31];
                exp_s<=exp_a;
                mant_s<=mant_a;
                next<=done;
            end
            else begin
                next<=equal;
            end
        end
        equal: begin
            if (exp_a == exp_b) begin
                next<=add;
            end
            else if (exp_a > exp_b) begin
                diff = exp_a - exp_b;
                mant_b <= mant_b >> diff;

                // 判断向上或向下舍入
                out = mant_b & ((1<<diff) - 1);
                if (out > (1 << (diff - 1))) begin
                    mant_b = mant_b + 1;
                    $display("here!");
                end
                else if (out == (1<<(diff - 1)) && mant_b[0] == 1) begin
                    mant_b = mant_b + 1;
                    $display("here!");
                end

                if (mant_b ==25'b0) begin
                    sign_s <= sign_a;
                    mant_s <= mant_a;
                    exp_s <= exp_a;
                    next <= done;
                end
                else begin
                    exp_b <= exp_a;
                    next <= add;
                end
            end
            else begin
                diff = exp_b - exp_a;
                mant_a = mant_a >> diff;

                out = mant_a & ((1<<diff) - 1);

                if (out > (1 << (diff - 1))) begin
                    mant_a = mant_a + 1;
                end
                else if (out == (1 << (diff - 1)) && mant_a[0] == 1) begin
                    mant_a = mant_a + 1;
                end

                if (mant_a == 25'b0) begin
                    sign_s <= sign_b;
                    mant_s <= mant_b;
                    exp_s <= exp_b;
                    next <= done;
                end
                else begin
                    exp_a <= exp_b;
                    next <= add;
                end
            end
        end

        add: begin
            if (sign_a == sign_b) begin
                exp_s <= exp_a;
                sign_s <= sign_a;
                mant_s <= mant_a + mant_b;
                next <= norm;
            end
            else begin
                if (mant_a > mant_b) begin
                    exp_s <= exp_a;
                    sign_s <= sign_a;
                    mant_s <= mant_a - mant_b;
                    next <= norm;
                end 
                else if (mant_a < mant_b) begin
                    exp_s <= exp_b;
                    sign_s <= sign_b;
                    mant_s <= mant_b - mant_a;
                    next <= norm;
                end
                else begin
                    exp_s <= exp_a;
                    mant_s <= 23'b0;
                    next <= done;
                end
            end
        end

        norm: begin
            if (mant_s[24] == 1'b1) begin
                if (mant_s[0] == 1) begin
                    mant_s <= mant_s + 1;
                    next <= norm;
                end
                else begin
                    mant_s <= {1'b0, mant_s[24:1]};
                    exp_s <= exp_s + 1;
                    next <= done;
                end
            end
            else begin
                if (mant_s[23] == 1'b0 && exp_s >= 1) begin
                    mant_s <= {mant_s[23:0], 1'b0};
                    exp_s <= exp_s - 1;
                    next <= norm;
                end
                else begin
                    next <= done;
                end
            end
        end

        done:begin
            s <= {sign_s, exp_s[7:0], mant_s[22:0]};
            next <= start;
        end

        default: begin
            next <= start;
        end
    endcase
end

endmodule
                



module adder(

    input x,

    input y,

    input cin,

    output s,

    output cout

);

assign s = x ^ y ^ cin;

assign cout = (x ^ y) & cin | x & y;

endmodule 

module fourAdder(

    input [4:1] x,

    input [4:1] y,

    input c0,

    output c4,Gm,Pm,

    output [4:1] s

);

wire c1,c2,c3;

wire p1,p2,p3,p4,g1,g2,g3,g4;

assign p1 = x[1] ^ y[1],p2 = x[2] ^ y[2],p3 = x[3] ^ y[3],p4 = x[4] ^ y[4];

assign g1 = x[1] & y[1],g2=x[2]&y[2],g3 = x[3]&y[3],g4=x[4]&y[4];

assign c1 = g1 ^ (p1 & c0),

c2 = g2 ^ (p2 & g1) ^ (p2 & p1 & c0),

c3 = g3 ^ (p3 & g2) ^ (p3 & p2 & g1) ^ (p3 & p2 & p1 & c0),

c4 = g4 ^ (p4 & g3) ^ (p4 & p3 & g2) ^ (p4 & p3 & p2 & g1) ^ (p4 & p3 & p2 & p1 & c0);

adder a1(

    .x(x[1]),

    .y(y[1]),

    .cin(c0),

    .s(s[1]),

    .cout()

);

adder a2(

    .x(x[2]),

    .y(y[2]),

    .cin(c1),

    .s(s[2]),

    .cout()

);

adder a3(

    .x(x[3]),

    .y(y[3]),

    .cin(c2),

    .s(s[3]),

    .cout()

);

adder a4(

    .x(x[4]),

    .y(y[4]),

    .cin(c3),

    .s(s[4]),

    .cout()

);

assign Pm = p1 & p2 & p3 & p4,

Gm = g4 ^ (p4 & g3) ^ (p4 & p3 & g2) ^ (p4 & p3 & p2 & g1);

endmodule

module CLA16(

    input [16 : 1] x,

    input [16 : 1] y,

    input c0,

    output Gm, Pm,

    output[16 : 1] s

);

wire  c4, c8, c12;

wire Pm1, Pm2, Pm3, Pm4, Gm1, Gm2, Gm3, Gm4;

fourAdder f1(.x(x[4 : 1]), .y(y[4 : 1]),.c0(c0), .c4(),.s(s[4 : 1]),.Gm(Gm1),.Pm(Pm1));

assign c4 = Gm1 ^ (Pm1 & c0);

fourAdder f2(.x(x[8 : 5]), .y(y[8: 5]), .c0(c4), .c4(), .s(s[8 : 5]), .Gm(Gm2), .Pm(Pm2));

assign c8 = Gm2 ^ (Pm2 & Gm1) ^ (Pm2 & Pm1 & c0);

fourAdder f3(.x(x[12 : 9]), .y(y[12 : 9]), .c0(c8), .c4(), .s(s[12 : 9]), .Gm(Gm3), .Pm(Pm3));

assign c12 = Gm3 ^ (Pm3 & Gm2) ^ (Pm3 & Pm2 & Gm1) ^ (Pm3 & Pm2 & Pm1 & c0);

fourAdder f4(.x(x[16 : 13]), .y(y[16 : 13]), .c0(c12), .c4(), .s(s[16 : 13]), .Gm(Gm4), .Pm(Pm4));

assign Pm = Pm1 & Pm2 & Pm3 & Pm4;

assign Gm = Gm4 ^ (Pm4 & Gm3) ^ (Pm4 & Pm3 & Gm2) ^ (Pm4 & Pm3 & Pm2 & Gm1);

endmodule



module Add(

    input       [31:0]          a,

    input       [31:0]          b,

    output [31:0]          sum

);

wire Pm1, Pm2, Gm1, Gm2;

wire c16;

CLA16 c1(.x(a[15 : 0]), .y(b[15:0]), .c0(0), .s(sum[15:0]), .Gm(Gm1), .Pm(Pm1));

assign c16 = Gm1 ^ (Pm1 & 0);

CLA16 c2(.x(a[31 : 16]), .y(b[31:16]), .c0(c16), .s(sum[31:16]), .Gm(Gm2), .Pm(Pm2));



endmodule
/*
    clk : posedge clock signal
    rst : posedge reset signal
    start : req 1 cycle signal
    layer_0 : req 64 cycle
    layer_1 : last until next start signal
    finish : last 1 cycle
 */
module Dense_1(
    input  wire clk, 
    input  wire rst,
    input  wire start,
    input  wire [16*64 - 1:0] layer_0,
    output reg  [32*10 - 1:0] layer_1,
    output reg  finish
    );
    localparam HEIGHT = 64;
    localparam WIDTH = 10;
    localparam [20479:0] kernel_1 = {-32'h00c8,32'h005a,32'h002c,-32'h0050,-32'h00ef,-32'h0023,-32'h010a,-32'h007d,-32'h0030,-32'h00af,-32'h00f3,-32'h0150,-32'h00d3,-32'h0038,32'h0038,-32'h0015,-32'h001f,-32'h0097,-32'h0021,-32'h0085,-32'h0093,32'h0018,-32'h0170,-32'h0277,-32'h00c7,32'h0096,32'h0041,-32'h000d,-32'h00ef,-32'h0196,-32'h00ab,32'h0050,-32'h00c9,-32'h0139,-32'h0005,-32'h00d3,32'h004c,-32'h0178,-32'h0126,-32'h0131,-32'h0050,-32'h010f,-32'h0018,32'h0013,-32'h01b9,32'h0038,-32'h0131,32'h0001,-32'h00e3,-32'h00b0,-32'h00cc,-32'h0139,32'h00cb,32'h0087,32'h0005,32'h0034,-32'h00f6,-32'h00cd,-32'h025e,-32'h010a,-32'h0043,-32'h00b2,-32'h004e,32'h009c,-32'h0144,-32'h0010,-32'h0019,-32'h010a,-32'h00d4,-32'h0191,-32'h0087,-32'h0191,-32'h0006,-32'h0088,32'h0088,32'h0000,-32'h0064,-32'h010d,-32'h001f,-32'h0037,-32'h00c0,-32'h01e3,-32'h0094,-32'h010b,32'h0096,-32'h00d2,-32'h005c,-32'h011c,32'h0064,32'h000c,-32'h0084,32'h0061,-32'h0156,-32'h0132,-32'h00cf,-32'h0057,32'h0018,-32'h011f,32'h0039,-32'h008d,-32'h0077,-32'h009c,-32'h00dd,-32'h0024,-32'h00b5,32'h0048,32'h0071,-32'h0161,-32'h007d,-32'h0244,-32'h00df,-32'h0006,32'h0007,-32'h0026,-32'h00c6,32'h0046,-32'h0089,-32'h00d6,-32'h0041,-32'h012c,-32'h00d3,32'h0059,-32'h007e,32'h004e,-32'h0083,-32'h00d7,-32'h0077,-32'h0142,-32'h002a,-32'h0017,-32'h00d4,32'h003e,32'h003e,-32'h001c,-32'h0184,-32'h007a,-32'h0063,32'h0055,-32'h0029,-32'h00df,-32'h00db,-32'h003a,32'h0055,-32'h000c,-32'h01cf,32'h001e,32'h006c,-32'h012d,-32'h00ae,-32'h0189,-32'h00df,-32'h0021,-32'h0097,-32'h0214,-32'h0013,-32'h0085,32'h004d,32'h0027,-32'h0168,-32'h008e,-32'h007c,32'h015a,32'h0000,-32'h0009,-32'h0161,-32'h019d,-32'h00bd,32'h005e,-32'h013c,-32'h0010,-32'h0065,-32'h007c,-32'h015e,-32'h011f,-32'h00e2,32'h0072,-32'h0182,-32'h0080,32'h001e,32'h0011,-32'h007e,32'h00bc,32'h0049,32'h0003,-32'h00db,-32'h0085,-32'h018a,-32'h000c,-32'h0164,-32'h004d,-32'h009e,-32'h018c,32'h00d7,-32'h015d,32'h00b7,-32'h004e,-32'h00a8,-32'h02fe,-32'h0163,-32'h0144,-32'h00a8,32'h0023,32'h00ad,32'h00bc,-32'h00ab,32'h0020,-32'h00ed,-32'h00cc,-32'h0282,-32'h0114,-32'h00c0,-32'h0157,-32'h01d1,-32'h00d2,-32'h0003,-32'h00cb,-32'h00c6,-32'h00e0,32'h005e,-32'h0003,-32'h0065,32'h00bd,-32'h0032,32'h001c,-32'h0104,-32'h01a8,-32'h00a7,-32'h00df,-32'h0086,32'h003f,-32'h0095,32'h0054,-32'h0071,-32'h013b,-32'h0141,-32'h0005,32'h0070,-32'h0102,-32'h003a,-32'h0136,-32'h00f0,32'h0064,-32'h0205,-32'h014e,-32'h0080,-32'h000c,32'h009e,-32'h0039,-32'h00d5,-32'h0132,-32'h0097,-32'h015f,32'h0051,-32'h01dd,32'h0022,-32'h00e5,-32'h0047,-32'h0097,-32'h00cc,-32'h0018,-32'h008b,-32'h00cd,-32'h0018,-32'h01c9,-32'h0012,-32'h0139,-32'h00d1,32'h0109,-32'h00f0,-32'h00ea,-32'h004a,-32'h0006,-32'h01eb,-32'h01c5,32'h0009,-32'h01bd,32'h0051,-32'h0108,-32'h0095,-32'h0035,-32'h00bf,32'h00d3,-32'h0134,-32'h0036,-32'h01ca,-32'h0062,-32'h0085,32'h0060,-32'h00c1,32'h000b,-32'h00ca,-32'h006a,32'h0146,-32'h0258,32'h0101,-32'h00fd,-32'h0120,-32'h03bd,-32'h0141,-32'h009d,-32'h007a,32'h007d,-32'h002d,-32'h00af,32'h0010,-32'h00b8,-32'h0151,32'h0039,-32'h0195,-32'h0064,-32'h00a6,32'h0118,-32'h00ed,32'h001d,-32'h01c1,-32'h00c4,-32'h0087,-32'h0030,-32'h00ba,32'h003b,-32'h007a,-32'h00c5,-32'h0154,-32'h0050,-32'h00d7,-32'h0056,-32'h0019,-32'h0188,-32'h0012,-32'h0123,-32'h0037,-32'h0060,32'h004e,-32'h0127,-32'h00bf,-32'h00e6,-32'h007b,32'h00f7,-32'h0198,-32'h0151,-32'h0055,-32'h0174,-32'h00ca,-32'h0003,32'h0059,-32'h0181,-32'h009c,-32'h01c9,-32'h009b,-32'h001a,-32'h00cc,32'h00c6,-32'h003d,-32'h00b5,-32'h0130,-32'h00bd,-32'h00c8,32'h0074,-32'h0187,-32'h001c,-32'h00a0,-32'h005e,-32'h013f,-32'h0195,-32'h003f,-32'h004a,-32'h0044,32'h00b9,-32'h00f2,-32'h0072,-32'h009a,32'h0088,-32'h001d,-32'h0130,-32'h0011,-32'h0148,-32'h00e1,32'h0072,-32'h01bb,-32'h0031,-32'h00e3,-32'h0104,-32'h0032,-32'h002c,-32'h0065,-32'h001f,-32'h01b4,-32'h001d,-32'h0030,-32'h0075,-32'h00cf,32'h00f8,-32'h0095,-32'h00a5,-32'h000a,-32'h01b2,-32'h012f,32'h000a,-32'h0166,-32'h000d,-32'h0062,-32'h00c2,32'h00d6,-32'h0033,-32'h02a4,32'h003b,-32'h023f,32'h00d3,-32'h00f5,-32'h00d9,-32'h00b0,-32'h015b,32'h002c,-32'h00c4,-32'h00d0,32'h000d,-32'h0079,-32'h0049,-32'h002c,-32'h008a,-32'h00bb,-32'h00e8,-32'h0100,-32'h0061,32'h0032,-32'h004f,-32'h0069,-32'h00c0,-32'h0039,-32'h002b,-32'h0098,32'h0014,-32'h0086,-32'h006c,-32'h00a7,-32'h013b,-32'h00eb,-32'h006d,32'h001e,-32'h0047,-32'h00a1,-32'h0038,-32'h0156,32'h000e,-32'h016a,32'h003b,-32'h00c9,-32'h0094,-32'h002b,-32'h00e4,-32'h00bf,-32'h007f,-32'h006d,32'h0038,32'h0019,-32'h011b,-32'h00f9,-32'h0027,-32'h0047,32'h0022,-32'h00dc,-32'h00bb,-32'h01d0,-32'h01a3,-32'h0033,32'h0012,-32'h0028,-32'h0033,-32'h00c8,32'h000c,-32'h008a,-32'h0084,-32'h0126,32'h00c4,-32'h007b,32'h000b,-32'h00dd,-32'h0018,-32'h003b,-32'h009c,-32'h00c3,-32'h01d7,-32'h0029,32'h003b,-32'h0004,-32'h004c,-32'h007e,-32'h0053,-32'h003b,-32'h0013,-32'h006b,-32'h0058,32'h00e2,-32'h00d0,-32'h0144,32'h000e,-32'h0188,32'h00bb,-32'h0102,-32'h0141,-32'h0069,-32'h00da,-32'h01bc,-32'h00f0,-32'h00bf,32'h006e,-32'h006c,-32'h00e3,-32'h0001,-32'h0054,-32'h00da,-32'h01d8,-32'h0101,-32'h0101,-32'h00d4,-32'h007a,32'h00b7,-32'h0100,-32'h0040,32'h001b,-32'h00b0,-32'h018b,-32'h00de,-32'h0034,-32'h0038,-32'h00a8,-32'h005b,-32'h016e,32'h00f1,-32'h0032,-32'h008b,-32'h009d,32'h0029,32'h00bc,-32'h029e,32'h0044,-32'h00b0,32'h0006,-32'h0193,-32'h0109,-32'h0105,-32'h00f5,-32'h002d,32'h0026,32'h0056,32'h0008,-32'h0006,-32'h0064,-32'h00ea,-32'h004e,-32'h005d,-32'h019b,-32'h0002,32'h0078,-32'h0129,-32'h00e9,-32'h00e3,-32'h0102,32'h0062,-32'h005f,-32'h00e2,-32'h00c5,-32'h001e,-32'h004a,-32'h0148,-32'h0036,-32'h00c3,-32'h0075,-32'h0067,32'h0012,-32'h009c,32'h006d,-32'h01c0,-32'h011c,-32'h0060,-32'h009f,32'h003e,32'h007b,-32'h00c4,32'h0003,-32'h00d2,-32'h018c,-32'h00ed,-32'h0044,32'h005d,-32'h00a0,32'h0094,-32'h00de,-32'h002d,-32'h0060,-32'h007c,-32'h0078,32'h001b,-32'h01f7,-32'h00cf,-32'h00a0,32'h00b0,-32'h0163,-32'h0028,-32'h00b1,-32'h0061,-32'h01ba,-32'h0042,-32'h004f,-32'h006d,-32'h0134,-32'h00cd,-32'h00b3,32'h00b1,32'h001d,-32'h006d,-32'h010b,-32'h0122,-32'h0050,-32'h00e2,-32'h0092,-32'h00a7,32'h006c,32'h0042,-32'h0074,-32'h00b8,32'h001b,32'h0014,32'h0018,-32'h01f4,-32'h0012,-32'h0153,-32'h0052,-32'h010e,-32'h0026,-32'h0051,-32'h02ca,32'h0110,-32'h01ce,32'h008d,-32'h00a9,-32'h00b8,-32'h01e8,-32'h0222,-32'h0026};
    localparam [319:0] bias_1 = {-32'h00c0,32'h010f,32'h0031,32'h001a,32'h0008,32'h007c,-32'h00ab,32'h0031,-32'h01f3,-32'h00f9};

    localparam SWAIT = 3'd0;
    localparam SDOT = 3'd1;
    localparam SBIAS = 3'd2;
    localparam SFIN = 3'd3;
    reg [2:0] state, next_state;

    // row * WIDTH + col
    reg  [16 - 1:0]     row, next_row;
    reg  [32*10 - 1:0]  next_layer_1;
    reg                 next_finish;
    wire [32 - 1:0]     curr_input_digit;
    reg  [32*10 - 1:0]  inp_mult_ker;

    // layer_0[(row+1)*16-1-:16]
    assign curr_input_digit = {{16{layer_0[(row+1)*16-1]}}, layer_0[(row+1)*16-1-:16]};

    always @(posedge clk ) begin
        if(rst) begin
            state <= SWAIT;
            row <= 0;
            layer_1 <= 0;
            finish <= 0;
        end else begin
            state <= next_state;
            row <= next_row;
            layer_1 <= next_layer_1;
            finish <= next_finish;
        end
    end
    // state
    always @(*) begin
        case (state)
            SWAIT: begin
                if(start) next_state = SDOT;
                else next_state = state;
            end
            SDOT: begin
                if(row == HEIGHT - 1) next_state = SBIAS;
                else next_state = state;
            end
            SBIAS: next_state = SFIN;
            default: next_state = SWAIT;
        endcase
    end
    // row, col
    always @(*) begin
        case (state)
            SDOT: next_row = row + 16'b1;
            default: next_row = 16'b0;
        endcase
    end
    // finish
    always @(*) begin
        case (state)
            SBIAS: next_finish = 1'b1;
            default: next_finish = 1'b0;
        endcase
    end
    // layer_1
    always @(*) begin
        inp_mult_ker[31-:32]  = (curr_input_digit * kernel_1[(row*10+0+1)*32-1-:32]);
        inp_mult_ker[63-:32]  = (curr_input_digit * kernel_1[(row*10+1+1)*32-1-:32]);
        inp_mult_ker[95-:32]  = (curr_input_digit * kernel_1[(row*10+2+1)*32-1-:32]);
        inp_mult_ker[127-:32] = (curr_input_digit * kernel_1[(row*10+3+1)*32-1-:32]);
        inp_mult_ker[159-:32] = (curr_input_digit * kernel_1[(row*10+4+1)*32-1-:32]);
        inp_mult_ker[191-:32] = (curr_input_digit * kernel_1[(row*10+5+1)*32-1-:32]);
        inp_mult_ker[223-:32] = (curr_input_digit * kernel_1[(row*10+6+1)*32-1-:32]);
        inp_mult_ker[255-:32] = (curr_input_digit * kernel_1[(row*10+7+1)*32-1-:32]);
        inp_mult_ker[287-:32] = (curr_input_digit * kernel_1[(row*10+8+1)*32-1-:32]);
        inp_mult_ker[319-:32] = (curr_input_digit * kernel_1[(row*10+9+1)*32-1-:32]);
        case (state)
            SWAIT: begin
                if(start) next_layer_1 = 0;
                else next_layer_1 = layer_1;
            end
            SDOT: begin
                next_layer_1[31-:32]  = layer_1[31-:32]  + {{8{inp_mult_ker[31] }},inp_mult_ker[31-:32-8] } ;
                next_layer_1[63-:32]  = layer_1[63-:32]  + {{8{inp_mult_ker[63] }},inp_mult_ker[63-:32-8] } ;
                next_layer_1[95-:32]  = layer_1[95-:32]  + {{8{inp_mult_ker[95] }},inp_mult_ker[95-:32-8] } ;
                next_layer_1[127-:32] = layer_1[127-:32] + {{8{inp_mult_ker[127]}},inp_mult_ker[127-:32-8]} ;
                next_layer_1[159-:32] = layer_1[159-:32] + {{8{inp_mult_ker[159]}},inp_mult_ker[159-:32-8]} ;
                next_layer_1[191-:32] = layer_1[191-:32] + {{8{inp_mult_ker[191]}},inp_mult_ker[191-:32-8]} ;
                next_layer_1[223-:32] = layer_1[223-:32] + {{8{inp_mult_ker[223]}},inp_mult_ker[223-:32-8]} ;
                next_layer_1[255-:32] = layer_1[255-:32] + {{8{inp_mult_ker[255]}},inp_mult_ker[255-:32-8]} ;
                next_layer_1[287-:32] = layer_1[287-:32] + {{8{inp_mult_ker[287]}},inp_mult_ker[287-:32-8]} ;
                next_layer_1[319-:32] = layer_1[319-:32] + {{8{inp_mult_ker[319]}},inp_mult_ker[319-:32-8]} ;
            end
            SBIAS: begin
                next_layer_1[31-:32] = layer_1[31-:32] + bias_1[31-:32];
                next_layer_1[63-:32] = layer_1[63-:32] + bias_1[63-:32];
                next_layer_1[95-:32] = layer_1[95-:32] + bias_1[95-:32];
                next_layer_1[127-:32] = layer_1[127-:32] + bias_1[127-:32];
                next_layer_1[159-:32] = layer_1[159-:32] + bias_1[159-:32];
                next_layer_1[191-:32] = layer_1[191-:32] + bias_1[191-:32];
                next_layer_1[223-:32] = layer_1[223-:32] + bias_1[223-:32];
                next_layer_1[255-:32] = layer_1[255-:32] + bias_1[255-:32];
                next_layer_1[287-:32] = layer_1[287-:32] + bias_1[287-:32];
                next_layer_1[319-:32] = layer_1[319-:32] + bias_1[319-:32];
            end
            SFIN: begin
                next_layer_1 = layer_1;
            end
            default: begin
                next_layer_1 = layer_1;
            end
        endcase
    end
endmodule
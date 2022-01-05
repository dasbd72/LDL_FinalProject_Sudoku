`timescale 1ps/1ps
module MouseDraw #(
    parameter SIZE = 52
    ) (
    input   wire            clk,
    input   wire            rst,
    input   wire [9 : 0]    MOUSE_X_POS,
    input   wire [9 : 0]    MOUSE_Y_POS,
    input   wire            MOUSE_LEFT,
    output  reg             valid,
    output  reg  [6 : 0]    block_pos,
    output  reg  [2703 : 0] track
    );

    localparam SWAIT = 2'd0;
    localparam SDRAW = 2'd1;
    localparam SEND  = 2'd1;
    localparam MAXCNT = 31'd150000000; // 10**8

    wire            SWAIT_2_SDRAW;
    wire            SDRAW_2_SEND;
    reg             next_valid;
    wire            mouse_pos_valid;
    wire            track_enable;
    wire [3:0]      block_x_pos, block_y_pos;
    reg  [6:0]      next_block_pos;
    reg  [2703:0]   next_track;
    reg  [1:0]      state, next_state;
    reg  [31:0]     count, next_count;

    always @(posedge clk) begin
        if(rst) begin
            valid       <= 1'b0;
            block_pos   <= 0;
            track       <= 0;
            state       <= SWAIT;
            count       <= 32'b0;
        end else begin
            valid       <= next_valid;
            block_pos   <= next_block_pos;
            track       <= next_track;
            state       <= next_state;
            count       <= next_count;
        end
    end
    
    assign mouse_pos_valid = (MOUSE_X_POS < SIZE * 9) && (MOUSE_Y_POS < SIZE * 9);
    assign track_enable = MOUSE_LEFT && 
                            (MOUSE_X_POS >= block_x_pos * SIZE) && 
                            (MOUSE_Y_POS >= block_y_pos * SIZE) && 
                            (MOUSE_X_POS < (block_x_pos + 1) * SIZE) && 
                            (MOUSE_Y_POS < (block_y_pos + 1) * SIZE);
    assign block_x_pos = MOUSE_X_POS / SIZE;
    assign block_y_pos = MOUSE_Y_POS / SIZE;
    assign SWAIT_2_SDRAW = MOUSE_LEFT && mouse_pos_valid;
    assign SDRAW_2_SEND = (count == (MAXCNT-1));

    // Value
    always @(*) begin
        case (state)
            SWAIT: begin
                next_track = 2703'b0;
            end
            SDRAW: begin
                if(SDRAW_2_SEND) begin
                    next_track = track;
                end else begin
                    if(track_enable) next_track[(MOUSE_Y_POS - block_y_pos * SIZE) * SIZE + (MOUSE_X_POS - block_x_pos * SIZE)] = 1'b1;
                    else next_track = track;
                end
            end
            default: next_track = 2703'b0;
        endcase

        case (state)
            SDRAW: begin
                if(SDRAW_2_SEND) next_valid = 1'b1;
                else next_valid = 1'b0;
            end
            default: next_valid = 1'b0;
        endcase

        case (state)
            SWAIT: next_block_pos = block_y_pos * 9 + block_x_pos;
            default: next_block_pos = block_pos;
        endcase
    end

    // State Change
    always @(*) begin
        case (state)
            SWAIT: begin
                if(SWAIT_2_SDRAW) next_state = SDRAW;
                else next_state = state;
            end
            SDRAW: begin
                if(SDRAW_2_SEND) next_state = SEND;
                else next_state = state;
            end
            default: next_state = SWAIT;
        endcase
    end

    // Counting Drawing Continuing time
    always @(*) begin
        case (state)
            SDRAW: next_count = count + 32'b1;
            default: next_count = 32'b0;
        endcase
    end
endmodule
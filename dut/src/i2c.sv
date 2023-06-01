`timescale 1ns/1ps

module i2c (
    input logic       clk,
    input logic       reset,
    input logic       start,
    input logic [6:0] addr,
    input logic [7:0] data,

    output logic      i2c_sda,
    output logic      i2c_scl,
    output logic      ready
);


    typedef enum logic [2:0] 
    {
        STATE_IDLE,     //00
        STATE_START,     //01
        STATE_ADDR,     //02
        STATE_RW,      //03
        STATE_WACK,
        STATE_DATA,
        STATE_WACK2,
        STATE_STOP
    } state;

    state current, next;

    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            current <= STATE_IDLE;
        end else begin
            current <= next;
        end
    end

    logic [7:0] count;
    logic i2c_scl_enable;

    logic [6:0] saved_addr;
    logic [7:0] saved_data;

    assign i2c_scl = (i2c_scl_enable == 0) ? 1 : ~clk;
    assign ready = ((reset == 0) && (current == STATE_IDLE)) ? 1 : 0;


    always_ff @(negedge clk) begin
        if (reset == 1) begin
            i2c_scl_enable <= 0;
        end
        else begin
            if((current == STATE_IDLE) || (current == STATE_START) || (current == STATE_STOP)) begin
                i2c_scl_enable <= 0;
            end
            else begin
                i2c_scl_enable <= 1;
            end    
        end
    end

    always_ff @(posedge clk) begin
            case (current)
                
                STATE_IDLE: begin
                    i2c_sda <= 1;
                    if(start) begin
                        next <= STATE_START;
                        saved_addr <= addr;
                        saved_data <= data;
                    end

                    else next <= STATE_IDLE;

                end

                STATE_START: begin
                    i2c_sda <= 0;
                    next <= STATE_ADDR;
                    count <= 6;
                    
                end

                STATE_ADDR: begin
                    i2c_sda <= saved_addr[count];
                    if(count == 0) next <= STATE_RW;
                    else count <= count - 1;
                    
                end

                STATE_RW: begin
                    i2c_sda <= 1;
                    next <= STATE_WACK;
                    
                end

                STATE_WACK: begin
                    next <= STATE_DATA;
                    count <= 7;
                    
                end

                STATE_DATA: begin
                    i2c_sda <= saved_data[count];
                    if(count == 0) next <= STATE_WACK2;
                    else count <= count - 1;
                    
                end

                STATE_WACK2: begin
                    next <= STATE_STOP;

                end

                STATE_STOP: begin
                    i2c_sda <= 1;
                    next <= STATE_IDLE;
                
                end
            endcase
        end


endmodule
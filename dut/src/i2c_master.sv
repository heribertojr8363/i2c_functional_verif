`timescale 1ns/1ps

module i2c_master (
    //Inputs coming from master device logic
    input logic       clk,
    input logic       reset,
    input logic       start,
    input logic       stop,
    input logic       rw,
    input logic [6:0] addr,
    input logic [7:0] w_data,
    input logic       i2c_sda_i,

    //Outputs
    output logic      i2c_scl,
    output  logic     i2c_sda_o
    
);

    typedef enum logic [2:0] 
    {
        STATE_IDLE,     //00
        STATE_START,     //01
        STATE_ADDR,     //02
        STATE_RW,      //03
        STATE_ACK,
        STATE_DATA,
        STATE_ACK2,
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
    logic [7:0] r_data;
    logic ack_addr;
    logic ack_data;
    logic [7:0] saved_wdata;


    assign i2c_scl = (i2c_scl_enable == 0) ? 1 : ~clk;
    //assign ready = ((reset == 0) && (current == STATE_IDLE)) ? 1 : 0;


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
                    i2c_sda_o <= 1;
                    if(start) begin
                        next <= STATE_START;
                        saved_addr <= addr;
                        saved_wdata <= w_data;
                    end

                    else next <= STATE_IDLE;

                end

                STATE_START: begin
                    i2c_sda_o <= 0;
                    next <= STATE_ADDR;
                    count <= 6;
                    
                end

                STATE_ADDR: begin
                    i2c_sda_o <= saved_addr[count];
                    if(count == 0) next <= STATE_RW;
                    else count <= count - 1;
                    
                end

                STATE_RW: begin
                    i2c_sda_o <= rw;
                    next <= STATE_ACK;
                    
                end

                STATE_ACK: begin
                    ack_addr <= i2c_sda_i;
                    if(!i2c_sda_i) begin
                        next <= STATE_DATA;
                        count <= 7;
                    end
                    else begin
                        i2c_sda_o <= 0;
                        next <= STATE_STOP;
                    end
                    
                end

                STATE_DATA: begin
                    if(!rw) begin
                        i2c_sda_o <= saved_wdata[count];
                    end

                    else begin
                        r_data[count] <= i2c_sda_i;
                    end

                    if(count == 0) next <= STATE_ACK2;
                    else count <= count - 1;
                    
                end

                STATE_ACK2: begin
                    ack_data <= i2c_sda_i;
                    if(!i2c_sda_i) begin
                        if(stop) begin
                            i2c_sda_o <= 0;
                            next <= STATE_STOP;
                        end
                        else next <= STATE_DATA;
                    end 
                    else begin
                        i2c_sda_o <= 0;
                        next <= STATE_STOP;
                    end

                end

                STATE_STOP: begin
                    i2c_sda_o <= 1;
                    next <= STATE_IDLE;
                
                end
            endcase
        end


endmodule

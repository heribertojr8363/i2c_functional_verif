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

    //Outputs
    output  logic     i2c_scl,
    inout   logic     i2c_sda
    
);

    typedef enum logic [2:0] 
    {
        STATE_IDLE,     //00
        STATE_START,    //01
        STATE_ADDR,     //02
        STATE_RW,       //03
        STATE_ACK,      //04
        STATE_DATA,     //05
        STATE_ACK2,     //06
        STATE_STOP      //07
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

    //logic sda_enable;
    //logic sda;

    // criar variavel io para definir a direção de i2c_sda


    assign i2c_scl = (i2c_scl_enable == 0) ? 1 : ~clk;

    //assign i2c_sda = (sda_enable) ? sda : 'bz;


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
                    if(start) begin
                        next <= STATE_START;
                    end

                    else next <= STATE_IDLE;

                end

                STATE_START: begin
                    next <= STATE_ADDR;
                    count <= 6;
                    
                end

                STATE_ADDR: begin
                    if(count == 0) next <= STATE_RW;
                    else count <= count - 1;
                    
                end

                STATE_RW: begin
                    next <= STATE_ACK;
                    
                end

                STATE_ACK: begin
                    if(!ack_addr) begin
                        next <= STATE_DATA;
                        count <= 7;
                    end
                    else begin
                        next <= STATE_STOP;
                    end
                    
                end

                STATE_DATA: begin
                    if(count == 0) next <= STATE_ACK2;
                    else count <= count - 1;
                    
                end

                STATE_ACK2: begin
                    if(!ack_data) begin
                        if(stop) begin
                            next <= STATE_STOP;
                        end
                        else next <= STATE_DATA;
                    end 
                    else begin
                        next <= STATE_STOP;
                    end

                end

                STATE_STOP: begin
                    next <= STATE_IDLE;
                
                end
            endcase
        end

    always_comb begin
        case (current)
            STATE_IDLE: begin
                    //sda_enable = 1;
                    sda = 1;
                    if(start) begin
                        saved_addr = addr;
                        saved_wdata = w_data;
                    end

                    else sda = sda;

                end

                STATE_START: begin
                    //sda_enable = 1;
                    sda = 0;
                    
                end

                STATE_ADDR: begin
                    //sda_enable = 1;
                    sda = saved_addr[count];
                    
                end

                STATE_RW: begin
                    //sda_enable = 1;
                    sda = rw;
                    
                end

                STATE_ACK: begin
                    //sda_enable = 1;
                    ack_addr = sda;
                    if(!ack_addr) begin
                        sda = sda;
                    end
                    else begin
                        sda = 0;
                    end
                    
                end

                STATE_DATA: begin
                    //sda_enable = 1;
                    if(!rw) begin
                        sda = saved_wdata[count];
                    end

                    else begin
                        r_data[count] = sda;
                    end
                    
                end

                STATE_ACK2: begin
                    //sda_enable = 1;
                    ack_data = sda;
                    if(!ack_data) begin
                        if(stop) begin
                            sda = 0;
                        end
                        else sda = sda;
                    end 
                    else begin
                        sda = 0;
                    end

                end

                STATE_STOP: begin
                    //sda_enable = 1;
                    sda = 1;
                
                end
                default: sda = 0;
        endcase
        
    end


endmodule

`include "uvm_macros.svh"
`include "i2c_pkg.svh"
`include "i2c_interface.svh"

module i2c_master (i2c_interface.master vif);

    typedef enum logic [3:0] 
    {
        STATE_IDLE,     //00
        STATE_START,    //01
        STATE_ADDR,     //02
        STATE_RW,       //03
        STATE_ACK,      //04
        STATE_WDATA,    //05
        STATE_RDATA,
        STATE_ACK_WDATA,//06
        STATE_ACK_RDATA,
        STATE_STOP      //07
    } state;

    state current, next;

    always_ff @(posedge vif.clk or posedge vif.reset) begin
        if(vif.reset) begin
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


    // criar variavel io para definir a direção de i2c_sda
    logic io;   // in (io = 0); out (io = 1);
    logic sda;
    logic sda_enable;

    assign vif.i2c_scl = (i2c_scl_enable == 0) ? 1 : ~vif.clk;

    assign vif.i2c_sda = (sda_enable) ? sda : 'bz;


    always_comb begin
        if (vif.reset == 1) begin
            i2c_scl_enable = 0;
        end
        else begin
            if((current == STATE_IDLE) || (current == STATE_START) || (current == STATE_STOP)) begin
                i2c_scl_enable = 0;
            end
            else begin
                i2c_scl_enable = 1;
            end    
        end
    end
    

    always_ff @(posedge vif.clk) begin
            case (current)
                
                STATE_IDLE: begin
                    if(vif.start) begin
                        next <= STATE_START;
                        //io <= 1;
                    end

                    else next <= STATE_IDLE;

                end

                STATE_START: begin
                    next <= STATE_ADDR;
                    count <= 6;
                    //io <= 1;
                    
                end

                STATE_ADDR: begin
                    if(count == 1) begin
                        next <= STATE_RW;
                        //io <= 1;
                    end

                    if(count != 0) begin
                        count <= count - 1;
                    end
                    
                end

                STATE_RW: begin
                    next <= STATE_ACK;
                    //io <= 1;
                    
                end

                STATE_ACK: begin
                    if(ack_addr) begin // ack tem que ser 1
                        if(!vif.rw) next <= STATE_WDATA;
                        else next <= STATE_RDATA;
                        count <= 7;
                        //io <= 0;
                    end
                    else begin
                        next <= STATE_ADDR;
                        //io <= 0;
                    end
                    
                end

                STATE_WDATA: begin
                    if(count == 1) begin
                        next <= STATE_ACK_WDATA;
                    end

                    if(count != 0) begin
                        count <= count - 1;
                    end
                    
                end

                STATE_RDATA: begin
                    if(count == 1) begin
                        next <= STATE_ACK_RDATA;
                    end

                    if(count != 0) begin
                        count <= count - 1;
                    end
                end

                STATE_ACK_WDATA: begin
                    if(!ack_data) begin
			if(vif.stop) next <= STATE_STOP;
                        //io <= 0;
                    end 
                    else begin
                        //io <= 0;
                        //Criar variável de nack
                        next <= STATE_WDATA;
                    end

                end

                STATE_ACK_RDATA: begin
                    next <= STATE_STOP;
                end

                STATE_STOP: begin
                    next <= STATE_IDLE;
                    //io <= 1;
                
                end
            endcase
        end

    always_comb begin
        case (current)
            STATE_IDLE: begin
                sda_enable = 1;
                io = 1;
                if(io)  sda = 1;
                else    sda = sda;
            end

            STATE_START: begin
                io = 1;
                sda_enable = 1;
		saved_addr = vif.addr;
                saved_wdata = vif.w_data;
                if(io) sda = 0;
                else   sda = sda;
                    
            end

            STATE_ADDR: begin
                io = 1;
                sda_enable = 1;
                if(io) sda = vif.addr[count];
                else   sda = sda;
                    
            end

            STATE_RW: begin
                io = 1;
                sda_enable = 1;
                if(io) sda = vif.rw;
                else   sda = sda;
                    
            end

            STATE_ACK: begin
                io = 0;
                sda_enable = 1;
                if(!io) begin
                    ack_addr = vif.i2c_sda;
		    sda = vif.i2c_sda;	
                end

                else begin
                    sda = sda;
                end
                    
            end

            STATE_WDATA: begin
                io = 1;
                sda_enable = 1;

                if(io) sda = vif.w_data[count];
                else sda = sda;
                    
            end

            STATE_RDATA: begin
                io = 0;
                sda_enable = 1;

                if(!io) r_data[count] = sda;
                else sda = sda;
            end

            STATE_ACK_WDATA: begin
                io = 0;
                sda_enable = 1;
                if(!io) begin
                    ack_data = vif.i2c_sda;
		    sda = vif.i2c_sda;
                end

                else begin
                    sda = sda;
                end

            end

            STATE_ACK_RDATA: begin
                io = 1;
                sda_enable = 1;

                if(io) sda = 0;
                else sda = sda;
            end

            STATE_STOP: begin
                io = 1;
                sda_enable = 1;
                if(io)   sda = 1;
                else     sda = sda;
                
             end

            default: sda = 0;
        endcase
        
    end


endmodule

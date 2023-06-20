`define TO_STRING(token) `"token`"

module xxx_tb();

  // ========================================================================================
  // Local parameters
  // ========================================================================================
  localparam integer PERIOD = 20; 
  localparam integer DLY0   = 0.01;  
  localparam integer DLY1   = 0.01;
  // ========================================================================================
  // Parameters
  // ========================================================================================
  parameter ADDR_WIDTH = 8;          
  parameter DATA_WIDTH = 8;       
  parameter TEST       = "basic";      // testcases: basic, all, etc
  // ========================================================================================
  // Interface
  // ========================================================================================
  reg                    dft_tm_i;
  reg                    clk_i;
  reg                    xxx_en_i;
  wire                   xxx_dt_valid_o;
  wire [ADDR_WIDTH -1:0] xxx_addr_o;
  wire [DATA_WIDTH -1:0] xxx_dt_o;
  // testbench signals
  reg                    tb_pass_r;
  //===================================================================================
  //Generic pins for the DFT flow
  //===================================================================================
  `ifdef DFT
    reg dft_shift_en;
    reg dft_sdi;
    reg dft_sdo;

    assign dft_shift_en = 1'b0;
    assign dft_sdi = 1'b0;
  `endif
  //===================================================================================
  // DUT Instance
  //===================================================================================
 `ifdef NETLIST
      xxx xxx (
  `else
      xxx #(
	    .ADDR_WIDTH      (ADDR_WIDTH), 
	    .DATA_WIDTH      (DATA_WIDTH) 
	    ) xxx (
  `endif  
  `ifdef DFT
	  //Declaration of the dft pins in the instance of your module
	    .dft_shift_en    (dft_shift_en),
	    .dft_sdi         (dft_sdi),
	    .dft_sdo         (dft_sdo),
  `endif
	    .dft_tm_i        (dft_tm_i),
	    .clk_i           (clk_i), 
	    .xxx_en_i        (xxx_en_i), 
	    .xxx_dt_valid_o  (xxx_dt_valid_o),
	    .xxx_addr_o      (xxx_addr_o),
	    .xxx_dt_o        (xxx_dt_o)  
  );   

  //===================================================================================
  //                                   Clock generation
  //===================================================================================
  always begin
    #(PERIOD/2) clk_i = !clk_i;
  end 
  //===================================================================================
  //                                   Stimulus generation
  //===================================================================================   
  
  task tst_basic;
  // checking
  integer         t_err;
  string          test;
  string          status;
    
    begin
    
	$display("//---------------------------------------------------------");
	$display("//                     TEST BASIC                          ");
	$display("//---------------------------------------------------------");
	$display("\n"); 
	
	xxx_en_i = 1'b0;
	repeat(2) @(posedge clk_i);
	#(DLY1);
	xxx_en_i = 1'b1;       
	
	@(posedge xxx_dt_valid_o) 
	  repeat(4) @(posedge clk_i);      
	    $display("//---------------------------------------------------------");
	    $display("//                      TEST results                     //");
	    $display("//---------------------------------------------------------");
	    $display("ADDR    = 16'h%h", xxx_addr_o);
	    $display("DATA    = 16'h%h", xxx_dt_o);        
	    
	    // checking of test
	    t_err = 0;
	    test = "TEST_BASIC";
	    if( xxx_dt_o == {DATA_WIDTH{1'b1}} )
		t_err = t_err;
	    else  
		t_err = t_err + 1;
	    if( t_err == 0 ) begin
		status    = "PASS";
	        tb_pass_r = tb_pass_r;
	    end
	    else begin 
		status = "FAIL";
	        tb_pass_r = 1'b1;
	    end
	    $display("TEST    = %s", test);
	    $display("STATUS  = %s", status);
	    $display("//---------------------------------------------------------");
	    $display("\n");   
	xxx_en_i = 1'b0;    
	repeat(4) @(posedge clk_i);
    end
  endtask 
  
  task test_all;
  begin

      $display("\n");
      $display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      $display("------------------------------------------------------------------------------------------");
      $display("!!!!!!!!!!!!!!!!!!!!!    SEQUENCE FOR ALL TESTCASES    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      $display("------------------------------------------------------------------------------------------");
      $display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      $display("\n");

      // tests ...
      
  end
  endtask

  task test_basic;
  begin

      $display("\n");
      $display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      $display("------------------------------------------------------------------------------------------");
      $display("!!!!!!!!!!!!!!!!!!!!!    SEQUENCE FOR BASIC CASES      !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      $display("------------------------------------------------------------------------------------------");
      $display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      $display("\n");

      // tests ... 
      tst_basic();
      
  end
  endtask
 
  //===================================================================================
  //                                   Stimulus generation
  //===================================================================================      
  //SDF annotation for the gatelevel simulation 
`ifdef NETLIST
  initial begin
      $sdf_annotate(`TO_STRING(`SDF_FILE),`DESIGN, ,`TO_STRING(`SDF_LOG_FILE),"MAXIMUM");
  end 
`endif

  initial begin
    dft_tm_i            = 1'b0; // To keep with logic value "0" (DFT)
    clk_i               = 1'b1;
    xxx_en_i            = 1'b0;
    tb_pass_r           = 1'b0;

    case (TEST)
          default:      test_all;
          "basic":      test_basic;
          "all":        test_all;
    endcase
    
    $display("\n##########################################################################################\n");     
      if( tb_pass_r == 1'b0 ) begin
        $display("\tPPPP   AA   SSS   SSS      !! !! !!\t");
        $display("\tP   P A  A S     S         !! !! !!\t");
        $display("\tPPPP  AAAA  SSS   SSS      !! !! !!\t");
        $display("\tP     A  A     S     S             \t");
        $display("\tP     A  A SSSS  SSSS      !! !! !!\t");
      end
      else begin
        $display("\tEEEE RRRR  RRRR   OOO  RRRR      !! !! !!\t"); 
        $display("\tE    R   R R   R O   O R   R     !! !! !!\t"); 
        $display("\tEEE  RRRR  RRRR  O   O RRRR      !! !! !!\t"); 
        $display("\tE    R R   R R   O   O R R               \t"); 
        $display("\tEEEE R  RR R  RR  OOO  R  RR     !! !! !!\t"); 
      end
    $display("\n##########################################################################################\n");
    $display ("finish simulation at time %d", $time , "ns\n");      
    $display("\n##########################################################################################\n");   
    $finish;
    
  end

endmodule
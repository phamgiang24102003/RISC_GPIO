module Memory #(parameter MEM_FILE = "",
                parameter SIZE = 4096)(
   input             clk,
   input             en_mem,
   input      [31:0] mem_addr,  // address to be read
   output reg [31:0] mem_rdata, // data read from memory
   input   	     mem_rstrb, // goes high when processor wants to read
   input      [31:0] mem_wdata, // data to be written
   input      [3:0]  mem_wmask	// masks for writing the 4 bytes (1=write byte)
);

   reg [31:0] MEM [0:SIZE-1]; // 1536 4-bytes words = 6 Kb of RAM in total
//    integer i;

//   initial begin
//    if (MEM_FILE!=0) begin
//        $readmemh(MEM_FILE,MEM);
//    end 
//   end

//   wire [29:0] word_addr = mem_addr[31:2];
   
   always @(posedge clk) begin
      if (en_mem == 1'b1) begin
          mem_rdata <= MEM[mem_addr];
          if(mem_wmask[0]) MEM[mem_addr][ 7:0 ] <= mem_wdata[ 7:0 ];
          if(mem_wmask[1]) MEM[mem_addr][15:8 ] <= mem_wdata[15:8 ];
          if(mem_wmask[2]) MEM[mem_addr][23:16] <= mem_wdata[23:16];
          if(mem_wmask[3]) MEM[mem_addr][31:24] <= mem_wdata[31:24];	
      end
   end


endmodule


















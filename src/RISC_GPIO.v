/*   

    DTP D21DT166
     module top


*/


module RISC_GPIO (
    input clk,
    input reset_n,
    
    inout [15:0] leds

);
    parameter MEM_FILE = "";

    wire mem_rstrb;
    wire mem_instr;
    wire mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0] mem_wstrb;
    wire [31:0] mem_rdata, rdata_gpio;
    wire [15:0] gpio_dir;

    wire s0_sel_mem;
    wire s1_sel_gpio;

    wire [15:0] gpio_out;


    reg [31:0] processor_rdata;
    always @(*) begin
        processor_rdata = 32'h0;
        case ({s1_sel_gpio, s0_sel_mem})
            2'b01: processor_rdata = mem_rdata;
            2'b10: processor_rdata = rdata_gpio;
        endcase
    end

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_leds_tristate
            assign leds[i] = (gpio_dir[i]) ? gpio_out[i] : 1'bz;
        end
    endgenerate




    FemtoRV32 processor (
        .clk      (clk),
        .reset    (reset_n),
        .mem_rstrb(mem_rstrb),
        .mem_rbusy(1'b0),
        .mem_wbusy(1'b0),
        .mem_addr (mem_addr),
        .mem_wdata(mem_wdata),
        .mem_wmask(mem_wstrb),
        .mem_rdata(processor_rdata)
    );
    
    Memory #(
        .MEM_FILE(MEM_FILE),
        .SIZE(32)
    ) D_mem_unit (
        .clk(clk),
        .mem_addr((mem_addr>>2)),
        .mem_rdata(mem_rdata),
        .mem_rstrb(s0_sel_mem & mem_rstrb),
        .en_mem(1'b1),
        .mem_wdata(mem_wdata),
        .mem_wmask({4{s0_sel_mem}} & mem_wstrb)
    );

    regs_GPIO gpio_unit(
        .clk(clk),
        .rst(!reset_n),

        // GPIO IO
        .csr_gpio_io_gpio_0_in (leds[0]),
        .csr_gpio_io_gpio_0_out(gpio_out[0]),
        .csr_gpio_io_gpio_1_in (leds[1]),
        .csr_gpio_io_gpio_1_out(gpio_out[1]),
        .csr_gpio_io_gpio_2_in (leds[2]),
        .csr_gpio_io_gpio_2_out(gpio_out[2]),
        .csr_gpio_io_gpio_3_in (leds[3]),
        .csr_gpio_io_gpio_3_out(gpio_out[3]),
        .csr_gpio_io_gpio_4_in (leds[4]),
        .csr_gpio_io_gpio_4_out(gpio_out[4]),
        .csr_gpio_io_gpio_5_in (leds[5]),
        .csr_gpio_io_gpio_5_out(gpio_out[5]),
        .csr_gpio_io_gpio_6_in (leds[6]),
        .csr_gpio_io_gpio_6_out(gpio_out[6]),
        .csr_gpio_io_gpio_7_in (leds[7]),
        .csr_gpio_io_gpio_7_out(gpio_out[7]),
        .csr_gpio_io_gpio_8_in (leds[8]),
        .csr_gpio_io_gpio_8_out(gpio_out[8]),
        .csr_gpio_io_gpio_9_in (leds[9]),
        .csr_gpio_io_gpio_9_out(gpio_out[9]),
        .csr_gpio_io_gpio_10_in (leds[10]),
        .csr_gpio_io_gpio_10_out(gpio_out[10]),
        .csr_gpio_io_gpio_11_in (leds[11]),
        .csr_gpio_io_gpio_11_out(gpio_out[11]),
        .csr_gpio_io_gpio_12_in (leds[12]),
        .csr_gpio_io_gpio_12_out(gpio_out[12]),
        .csr_gpio_io_gpio_13_in (leds[13]),
        .csr_gpio_io_gpio_13_out(gpio_out[13]),
        .csr_gpio_io_gpio_14_in (leds[14]),
        .csr_gpio_io_gpio_14_out(gpio_out[14]),
        .csr_gpio_io_gpio_15_in (leds[15]),
        .csr_gpio_io_gpio_15_out(gpio_out[15]),

        // GPIO Config (Direction)
        .csr_gpio_config_gpio_0_config_out (gpio_dir[0]),
        .csr_gpio_config_gpio_1_config_out (gpio_dir[1]),
        .csr_gpio_config_gpio_2_config_out (gpio_dir[2]),
        .csr_gpio_config_gpio_3_config_out (gpio_dir[3]),
        .csr_gpio_config_gpio_4_config_out (gpio_dir[4]),
        .csr_gpio_config_gpio_5_config_out (gpio_dir[5]),
        .csr_gpio_config_gpio_6_config_out (gpio_dir[6]),
        .csr_gpio_config_gpio_7_config_out (gpio_dir[7]),
        .csr_gpio_config_gpio_8_config_out (gpio_dir[8]),
        .csr_gpio_config_gpio_9_config_out (gpio_dir[9]),
        .csr_gpio_config_gpio_10_config_out(gpio_dir[10]),
        .csr_gpio_config_gpio_11_config_out(gpio_dir[11]),
        .csr_gpio_config_gpio_12_config_out(gpio_dir[12]),
        .csr_gpio_config_gpio_13_config_out(gpio_dir[13]),
        .csr_gpio_config_gpio_14_config_out(gpio_dir[14]),
        .csr_gpio_config_gpio_15_config_out(gpio_dir[15]),

        // Local Bus
        .waddr ({4'h0, mem_addr[27:0]}),
        .wdata (mem_wdata),
        .wen   (s1_sel_gpio & (|mem_wstrb)),
        .wstrb (mem_wstrb),
        .wready(),

        .raddr ({4'h0, mem_addr[27:0]}),
        .ren   (s1_sel_gpio & mem_rstrb),
        .rdata (rdata_gpio),
        .rvalid()
    );

    device_select dv_sel(
        .addr(mem_addr),
        .s0_sel_mem(s0_sel_mem),
        .s1_sel_gpio(s1_sel_gpio)
    );
    

endmodule

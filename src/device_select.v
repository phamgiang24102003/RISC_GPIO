module device_select (
    input [31:0] addr,
    output s0_sel_mem,
    output s1_sel_gpio
);


  wire mem_space = (addr[31:28] == 4'h0);
  wire gpio_space = (addr[31:28] == 4'h4);

  assign s0_sel_mem  = mem_space;
  assign s1_sel_gpio = gpio_space;

endmodule

// Wrapper for 5k hard IP
module ip_wrapper_up5k(
  input clock,
  input reset,
  input  [23:0] address,
  input  [31:0] write_data,
  output [31:0] read_data,
  input  [3:0]  wstrb,
  input         valid,
  output reg ready,
  
  output [2:0]  pwm,
  
  input sdai_1,
  output sdao_1,
  output sdaoe_1,
  input scli_1,
  output sclo_1,
  output scloe_1,

  input sdai_2,
  output sdao_2,
  output sdaoe_2,
  input scli_2,
  output sclo_2,
  output scloe_2,

  inout spi_miso,
  inout spi_mosi,
  inout spi_sck
);

wire led_en, ctrl_en, spi_en;
wire i2c_en;

assign led_en = (address[23:16] == 8'h00);
assign i2c_en = (address[23:16] == 8'h01);
assign ctrl_en = (address[23:16] == 8'h10);
assign spi_en = (address[23:16] == 8'h03);

wire [7:0] i2c_read_data_1;
wire i2c_ack_1;

wire [7:0] i2c_read_data_2;
wire i2c_ack_2;

wire [7:0] spi_read_data;
wire spi_ack;

reg [31:0] rdata_reg;
reg ready;

reg [7:0] ctrl_reg;

always @(posedge clock)
begin
  if(!valid)
    ready <= 1'b0;
  if(!ready && led_en && valid) 
  begin
    ready <= 1'b1;
    rdata_reg <= 32'h0;
  end else if(!ready && ctrl_en && valid)
  begin
    ready <= 1'b1;
    if(wstrb[0])
      ctrl_reg <= write_data;
    rdata_reg <= {24'h0, ctrl_reg};
  end 
  else if(!ready && i2c_en && i2c_ack_1 && valid)
  begin
    ready <= 1'b1;
    rdata_reg <= i2c_read_data_1;
  end
  else if(!ready && i2c_en && i2c_ack_2 && valid)
  begin
    ready <= 1'b1;
    rdata_reg <= i2c_read_data_2;
  end
  else if(!ready && spi_en && spi_ack && valid)
  begin
    ready <= 1'b1;
    rdata_reg <= spi_read_data;
  end
end

assign read_data = rdata_reg;

SB_LEDDA_IP ledda_i (
  .LEDDCS(led_en),
  .LEDDCLK(clock),
  .LEDDDAT7(write_data[7]),
  .LEDDDAT6(write_data[6]),
  .LEDDDAT5(write_data[5]),
  .LEDDDAT4(write_data[4]),
  .LEDDDAT3(write_data[3]),
  .LEDDDAT2(write_data[2]),
  .LEDDDAT1(write_data[1]),
  .LEDDDAT0(write_data[0]),
  .LEDDADDR3(address[5]),
  .LEDDADDR2(address[4]),
  .LEDDADDR1(address[3]),
  .LEDDADDR0(address[2]),
  .LEDDDEN(led_en && valid && !ready && wstrb[0]),
  .LEDDEXE(ctrl_reg[0]),
  .PWMOUT0(pwm[0]),
  .PWMOUT1(pwm[1]),
  .PWMOUT2(pwm[2])
);

// I2C 1st block

SB_I2C #(
  .I2C_SLAVE_INIT_ADDR("0b1111100001"),
  .BUS_ADDR74("0b0001")
) i2c_block_1 (
  .SBCLKI(clock),
  .SBRWI(wstrb[0]),
  .SBSTBI(valid && i2c_en && !ready),
  .SBADRI0(address[2]),
  .SBADRI1(address[3]),
  .SBADRI2(address[4]),
  .SBADRI3(address[5]),
  .SBADRI4(address[6]),
  .SBADRI5(address[7]),
  .SBADRI6(address[8]),
  .SBADRI7(address[9]),
  .SBDATI0(write_data[0]),
  .SBDATI1(write_data[1]),
  .SBDATI2(write_data[2]),
  .SBDATI3(write_data[3]),
  .SBDATI4(write_data[4]),
  .SBDATI5(write_data[5]),
  .SBDATI6(write_data[6]),
  .SBDATI7(write_data[7]),
  .SBDATO0(i2c_read_data_1[0]),
  .SBDATO1(i2c_read_data_1[1]),
  .SBDATO2(i2c_read_data_1[2]),
  .SBDATO3(i2c_read_data_1[3]),
  .SBDATO4(i2c_read_data_1[4]),
  .SBDATO5(i2c_read_data_1[5]),
  .SBDATO6(i2c_read_data_1[6]),
  .SBDATO7(i2c_read_data_1[7]),
  .SBACKO(i2c_ack_1),
  .I2CIRQ(),
  .I2CWKUP(),
  .SCLI(scli_1),
  .SCLO(sclo_1),
  .SCLOE(scloe_1),
  .SDAI(sdai_1),
  .SDAO(sdao_1),
  .SDAOE(sdaoe_1)
);

// I2C 2nd block

SB_I2C #(
  .I2C_SLAVE_INIT_ADDR("0b1111100001"),
  .BUS_ADDR74("0b0011")
) i2c_block_2 (
  .SBCLKI(clock),
  .SBRWI(wstrb[0]),
  .SBSTBI(valid && i2c_en && !ready),
  .SBADRI0(address[2]),
  .SBADRI1(address[3]),
  .SBADRI2(address[4]),
  .SBADRI3(address[5]),
  .SBADRI4(address[6]),
  .SBADRI5(address[7]),
  .SBADRI6(address[8]),
  .SBADRI7(address[9]),
  .SBDATI0(write_data[0]),
  .SBDATI1(write_data[1]),
  .SBDATI2(write_data[2]),
  .SBDATI3(write_data[3]),
  .SBDATI4(write_data[4]),
  .SBDATI5(write_data[5]),
  .SBDATI6(write_data[6]),
  .SBDATI7(write_data[7]),
  .SBDATO0(i2c_read_data_2[0]),
  .SBDATO1(i2c_read_data_2[1]),
  .SBDATO2(i2c_read_data_2[2]),
  .SBDATO3(i2c_read_data_2[3]),
  .SBDATO4(i2c_read_data_2[4]),
  .SBDATO5(i2c_read_data_2[5]),
  .SBDATO6(i2c_read_data_2[6]),
  .SBDATO7(i2c_read_data_2[7]),
  .SBACKO(i2c_ack_2),
  .I2CIRQ(),
  .I2CWKUP(),
  .SCLI(scli_2),
  .SCLO(sclo_2),
  .SCLOE(scloe_2),
  .SDAI(sdai_2),
  .SDAO(sdao_2),
  .SDAOE(sdaoe_2)
);



// SPI Block
wire mi;
wire so;
wire soe;
wire si;
wire mo;
wire moe;
wire scki;
wire scko;
wire sckoe;

wire mcsno3,mcsno2,mcsno1,mcsno0;
wire mcsnoe3,mcsnoe2,mcsnoe1,mcsnoe0;

SB_SPI #(
  .BUS_ADDR74("0b0000")
) spi_i (
  .SBCLKI(clock),
  .SBRWI(wstrb[0]),
  .SBSTBI(valid && spi_en && !ready),
  .SBADRI0(address[2]),
  .SBADRI1(address[3]),
  .SBADRI2(address[4]),
  .SBADRI3(address[5]),
  .SBADRI4(address[6]),
  .SBADRI5(address[7]),
  .SBADRI6(address[8]),
  .SBADRI7(address[9]),
  .SBDATI0(write_data[0]),
  .SBDATI1(write_data[1]),
  .SBDATI2(write_data[2]),
  .SBDATI3(write_data[3]),
  .SBDATI4(write_data[4]),
  .SBDATI5(write_data[5]),
  .SBDATI6(write_data[6]),
  .SBDATI7(write_data[7]),
  .SBDATO0(spi_read_data[0]),
  .SBDATO1(spi_read_data[1]),
  .SBDATO2(spi_read_data[2]),
  .SBDATO3(spi_read_data[3]),
  .SBDATO4(spi_read_data[4]),
  .SBDATO5(spi_read_data[5]),
  .SBDATO6(spi_read_data[6]),
  .SBDATO7(spi_read_data[7]),
	.MI(mi),
	.SO(so),
	.SOE(soe),
	.SI(si),
	.MO(mo),
	.MOE(moe),
	.SCKI(scki),
	.SCKO(scko),
	.SCKOE(sckoe),
	.SCSNI(1'b1),
	.SBACKO(spi_ack),
	.SPIIRQ(),
	.SPIWKUP(),
	.MCSNO3(mcsno3),
	.MCSNO2(mcsno2),
	.MCSNO1(mcsno1),
	.MCSNO0(mcsno0),
	.MCSNOE3(mcsnoe3),
	.MCSNOE2(mcsnoe2),
	.MCSNOE1(mcsnoe1),
	.MCSNOE0(mcsnoe0)
);

SB_IO #(
  .PIN_TYPE(6'b101001),
) miso_io (
  .PACKAGE_PIN(spi_miso),
  .OUTPUT_ENABLE(soe),
  .D_OUT_0(so),
  .D_IN_0(mi)
);

SB_IO #(
  .PIN_TYPE(6'b101001),
) mosi_io (
  .PACKAGE_PIN(spi_mosi),
  .OUTPUT_ENABLE(moe),
  .D_OUT_0(mo),
  .D_IN_0(si)
);

SB_IO #(
  .PIN_TYPE(6'b101001),
  .PULLUP(1'b1)
) sck_io (
  .PACKAGE_PIN(spi_sck),
  .OUTPUT_ENABLE(sckoe),
  .D_OUT_0(scko),
  .D_IN_0(scki)
);

endmodule
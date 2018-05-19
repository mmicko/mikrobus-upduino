/*
 *  PicoSoC - A simple example SoC using PicoRV32
 *
 *  Copyright (C) 2017  Clifford Wolf <clifford@clifford.at>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

module mikrobus_soc (
	output ser_tx,
	input ser_rx,

	output flash_csb,
	output flash_clk,
	inout  flash_io0,
	inout  flash_io1,
	inout  flash_io2,
	inout  flash_io3,
		
	output RGB0, RGB1, RGB2,
	
	inout AN_1,
	inout RST_1,
	inout CS_1,
	inout PWM_1,
	inout INT_1,
	inout AN_2,
	inout RST_2,
	inout CS_2,
	inout PWM_2,
	inout INT_2,

	inout SDA_1, SCL_1,	
	inout SDA_2, SCL_2,
	inout MISO_1, MOSI_1, SCK_1
	
);
	wire clk;

	SB_HFOSC #(.CLKHF_DIV("0b10")) u_SB_HFOSC(.CLKHFPU(1), .CLKHFEN(1), .CLKHF(clk));

	reg [5:0] reset_cnt = 0;
	wire resetn = &reset_cnt;

	always @(posedge clk) begin
		reset_cnt <= reset_cnt + !resetn;
	end

	wire flash_io0_oe, flash_io0_do, flash_io0_di;
	wire flash_io1_oe, flash_io1_do, flash_io1_di;
	wire flash_io2_oe, flash_io2_do, flash_io2_di;
	wire flash_io3_oe, flash_io3_do, flash_io3_di;

	SB_IO #(
		.PIN_TYPE(6'b 1010_01),
		.PULLUP(1'b 0)
	) flash_io_buf [3:0] (
		.PACKAGE_PIN({flash_io3, flash_io2, flash_io1, flash_io0}),
		.OUTPUT_ENABLE({flash_io3_oe, flash_io2_oe, flash_io1_oe, flash_io0_oe}),
		.D_OUT_0({flash_io3_do, flash_io2_do, flash_io1_do, flash_io0_do}),
		.D_IN_0({flash_io3_di, flash_io2_di, flash_io1_di, flash_io0_di})
	);

	reg [31:0] gpio_oe;
	reg [31:0] gpio_do;
	wire [9:0] gpio_di;

	SB_IO #(
		.PIN_TYPE(6'b 1010_01),
		.PULLUP(1'b 0)
	) gpio_control [9:0] (
		.PACKAGE_PIN({AN_1, RST_1, CS_1, PWM_1, INT_1, AN_2, RST_2, CS_2, PWM_2, INT_2}),
		.OUTPUT_ENABLE(gpio_oe[9:0]),
		.D_OUT_0(gpio_do[9:0]),
		.D_IN_0(gpio_di[9:0])
	);

	wire        iomem_valid;
	reg         iomem_ready;
	wire [3:0]  iomem_wstrb;
	wire [31:0] iomem_addr;
	wire [31:0] iomem_wdata;
	reg  [31:0] iomem_rdata;

	wire ip_ready;
	wire [31:0] ip_rdata; 

	always @(posedge clk) begin
		if (!resetn) begin
			gpio_oe <= 0;
			gpio_do <= 0;
		end else begin
			iomem_ready <= 0;
			if (iomem_valid && !iomem_ready && iomem_addr[31:24] == 8'h 03) begin
				iomem_ready <= 1;
				if (iomem_addr == 32'h 0300_0004)
				begin
					if (iomem_wstrb[0]) gpio_oe[ 7: 0] <= iomem_wdata[ 7: 0];
					if (iomem_wstrb[1]) gpio_oe[15: 8] <= iomem_wdata[15: 8];
					if (iomem_wstrb[2]) gpio_oe[23:16] <= iomem_wdata[23:16];
					if (iomem_wstrb[3]) gpio_oe[31:24] <= iomem_wdata[31:24];
				end
				else if (iomem_addr == 32'h 0300_0000)
				begin
					iomem_rdata <= gpio_di;
					if (iomem_wstrb[0]) gpio_do[ 7: 0] <= iomem_wdata[ 7: 0];
					if (iomem_wstrb[1]) gpio_do[15: 8] <= iomem_wdata[15: 8];
					if (iomem_wstrb[2]) gpio_do[23:16] <= iomem_wdata[23:16];
					if (iomem_wstrb[3]) gpio_do[31:24] <= iomem_wdata[31:24];
				end	
				else 
				begin
					iomem_rdata <= 32'h 0000_0000;
				end											
			end else if (iomem_valid && !iomem_ready && iomem_addr[31:24] == 8'h 04) begin
				iomem_ready <= 1;
				iomem_rdata <= 32'd0;
			end else if (iomem_valid && !iomem_ready && iomem_addr[31:24] == 8'h 05) begin // Hard IP
				iomem_ready <= ip_ready;
				iomem_rdata <= ip_rdata;
			end
		end
	end

	picosoc soc (
		.clk          (clk         ),
		.resetn       (resetn      ),

		.ser_tx       (ser_tx      ),
		.ser_rx       (ser_rx      ),

		.flash_csb    (flash_csb   ),
		.flash_clk    (flash_clk   ),

		.flash_io0_oe (flash_io0_oe),
		.flash_io1_oe (flash_io1_oe),
		.flash_io2_oe (flash_io2_oe),
		.flash_io3_oe (flash_io3_oe),

		.flash_io0_do (flash_io0_do),
		.flash_io1_do (flash_io1_do),
		.flash_io2_do (flash_io2_do),
		.flash_io3_do (flash_io3_do),

		.flash_io0_di (flash_io0_di),
		.flash_io1_di (flash_io1_di),
		.flash_io2_di (flash_io2_di),
		.flash_io3_di (flash_io3_di),

		.irq_5        (1'b0        ),
		.irq_6        (1'b0        ),
		.irq_7        (1'b0        ),

		.iomem_valid  (iomem_valid ),
		.iomem_ready  (iomem_ready ),
		.iomem_wstrb  (iomem_wstrb ),
		.iomem_addr   (iomem_addr  ),
		.iomem_wdata  (iomem_wdata ),
		.iomem_rdata  (iomem_rdata )
	);
	
	
	wire ip_valid = iomem_valid && (iomem_addr[31:24] == 8'h 05);
	
	wire pwm_g, pwm_b, pwm_r;

	ip_wrapper_up5k ip(
		.clock(clk),
		.reset(!resetn),
		.address(iomem_addr[23:0]),
		.write_data(iomem_wdata),
		.read_data(ip_rdata),
		.wstrb(iomem_wstrb),
		.valid(ip_valid),
		.ready(ip_ready),
		
		.pwm({pwm_r, pwm_g, pwm_b}),
		
		.i2c_sda_1(SDA_1),
		.i2c_scl_1(SCL_1),

		.i2c_sda_2(SDA_2),
		.i2c_scl_2(SCL_2),

		.spi_miso(MISO_1),
		.spi_mosi(MOSI_1),
		.spi_sck(SCK_1)
	);
	
	
	SB_RGBA_DRV RGBA_DRIVER (
	  .CURREN(1'b1),
	  .RGBLEDEN(1'b1),
	  .RGB0PWM(pwm_g),
	  .RGB1PWM(pwm_b),
	  .RGB2PWM(pwm_r),
	  .RGB0(RGB0),
	  .RGB1(RGB1),
	  .RGB2(RGB2)
	);


	defparam RGBA_DRIVER.CURRENT_MODE = "0b1";
	defparam RGBA_DRIVER.RGB0_CURRENT = "0b000111";
	defparam RGBA_DRIVER.RGB1_CURRENT = "0b000111";
	defparam RGBA_DRIVER.RGB2_CURRENT = "0b000111";
endmodule

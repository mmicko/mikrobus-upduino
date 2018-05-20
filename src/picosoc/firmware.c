#include <stdint.h>
#include <stdbool.h>


#define PIN_AN_1   1 << 9
#define PIN_RST_1  1 << 8
#define PIN_CS_1   1 << 7
#define PIN_PWM_1  1 << 6
#define PIN_INT_1  1 << 5
#define PIN_AN_2   1 << 4
#define PIN_RST_2  1 << 3
#define PIN_CS_2   1 << 2
#define PIN_PWM_2  1 << 1
#define PIN_INT_2  1 << 0

#define reg_spictrl (*(volatile uint32_t*)0x02000000)
#define reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define reg_uart_data (*(volatile uint32_t*)0x02000008)
#define reg_gpio_data (*(volatile uint32_t*)0x03000000)
#define reg_gpio_mode (*(volatile uint32_t*)0x03000004)
#define reg_text ((volatile uint32_t*)0x04000000)
#define reg_i2c ((volatile uint32_t*)0x05010040)
#define reg_spi ((volatile uint32_t*)0x05030000)
#define reg_ctrl ((volatile uint32_t*)0x05100000)

// --------------------------------------------------------

void putchar(char c)
{
	if (c == '\n')
		putchar('\r');
	reg_uart_data = c;
}

void print(const char *p)
{
	while (*p)
		putchar(*(p++));
}

void print_hex(uint32_t v, int digits)
{
	for (int i = 7; i >= 0; i--) {
		char c = "0123456789abcdef"[(v >> (4*i)) & 15];
		if (c == '0' && i >= digits) continue;
		putchar(c);
		digits = i;
	}
}

void print_dec(uint32_t v)
{
	if (v >= 100) {
		print(">=100");
		return;
	}

	if      (v >= 90) { putchar('9'); v -= 90; }
	else if (v >= 80) { putchar('8'); v -= 80; }
	else if (v >= 70) { putchar('7'); v -= 70; }
	else if (v >= 60) { putchar('6'); v -= 60; }
	else if (v >= 50) { putchar('5'); v -= 50; }
	else if (v >= 40) { putchar('4'); v -= 40; }
	else if (v >= 30) { putchar('3'); v -= 30; }
	else if (v >= 20) { putchar('2'); v -= 20; }
	else if (v >= 10) { putchar('1'); v -= 10; }

	if      (v >= 9) { putchar('9'); v -= 9; }
	else if (v >= 8) { putchar('8'); v -= 8; }
	else if (v >= 7) { putchar('7'); v -= 7; }
	else if (v >= 6) { putchar('6'); v -= 6; }
	else if (v >= 5) { putchar('5'); v -= 5; }
	else if (v >= 4) { putchar('4'); v -= 4; }
	else if (v >= 3) { putchar('3'); v -= 3; }
	else if (v >= 2) { putchar('2'); v -= 2; }
	else if (v >= 1) { putchar('1'); v -= 1; }
	else putchar('0');
}


#define I2CCR1 		(0x08)
#define I2CCMDR 	(0x09)
#define I2CBRLSB 	(0x0A)
#define I2CBRMSB 	(0x0B)
#define I2CSR		(0x0C)
#define I2CTXDR 	(0x0D)
#define I2CRXDR 	(0x0E)
#define I2CGCDR 	(0x0F)
#define I2CSADDR 	(0x03)
#define I2CINTCR 	(0x07)
#define I2CINTSR 	(0x06)

inline void i2c_wait(uint8_t offset) 
{
	while((reg_i2c[I2CSR+offset] & 0x04) == 0);
}

inline void i2c_wait_srw(uint8_t offset) 
{
	while((reg_i2c[I2CSR+offset] & 0x10) == 0);
}

void i2c_begin(uint8_t offset,uint8_t addr, bool is_read) 
{
	reg_i2c[I2CTXDR+offset] = (addr << 1) | (is_read & 0x01);
	reg_i2c[I2CCMDR+offset] = 0x94;
	
	if(is_read) 
	{
		i2c_wait_srw(offset);
		reg_i2c[I2CCMDR+offset] = 0x24;

	} else 
	{
		i2c_wait(offset);
	}
}

void i2c_write(uint8_t offset,uint8_t data) 
{
	reg_i2c[I2CTXDR+offset] = data;
	reg_i2c[I2CCMDR+offset] = 0x14;
	i2c_wait(offset);
	reg_i2c[I2CCMDR+offset] = 0x0;
}

void i2c_stop(uint8_t offset) 
{
	reg_i2c[I2CCMDR+offset] = 0x44;
}

void i2c_init(uint8_t offset) 
{
	reg_i2c[I2CCR1+offset] = 0x80;
	uint16_t prescale = 50;
	reg_i2c[I2CBRMSB+offset] = (prescale >> 8) & 0xFF;
	reg_i2c[I2CBRLSB+offset] = prescale & 0xFF;
}


void delay_cyc(uint32_t cycles) {
	uint32_t cycles_begin, cycles_now;
	__asm__ volatile ("rdcycle %0" : "=r"(cycles_begin));
	do {
		__asm__ volatile ("rdcycle %0" : "=r"(cycles_now));
	} while((cycles_now - cycles_begin) < cycles);
	
}
void _delay_us(uint32_t us)
{
	delay_cyc(12*us);
}

void _delay_ms(uint32_t ms)
{
	delay_cyc(12050*ms);
}

uint8_t i2c_read(uint8_t offset,bool is_last) 
{
	if(is_last)
	{
		uint8_t dummy = reg_i2c[I2CRXDR + offset];		
		reg_i2c[I2CCMDR + offset] = 0x6C;
		i2c_wait(offset);
		uint8_t data = reg_i2c[I2CRXDR + offset];
		return data;
	} 
	else 
	{
		i2c_wait(offset);
		return reg_i2c[I2CRXDR + offset] & 0xFF;
	}
}

int i2c_scan(uint8_t offset,uint8_t addr)
{
	uint8_t d;	
	i2c_begin(offset,addr, false);
	i2c_write(offset,0x00);
	i2c_begin(offset,addr, true);
	_delay_us(20);
	d = reg_i2c[I2CSR + offset];
	i2c_read(offset,true);
	return (d & 0x20)==0x00;
}


void print_dec_ex(int i) 
{
	char buf[10];
	char *ptr = buf;
	if(i < 0) 
	{
		i = -i;
		print("-");
	}
	if(i == 0) {
		print("0");
	}
	while(i > 0) {
		*(ptr++) = '0' + (i % 10);
		i /= 10;
	}
	char rev[10];
	char *rptr = rev;
	while(ptr != buf) {
		*(rptr++) = *(--ptr);
	}
	*rptr = '\0';
	print(rev);
}

void i2c_test(uint8_t offset) 
{
	i2c_init(offset);

	print("scan:\n");
	int val[0x80];
	bool found = false;

	for(int i=0x1;i<0x80;i++)
	{
		val[i] = i2c_scan(offset,i);
		if(val[i]) found = true;
	}

	if (found)
	{
		print("found i2c at: ");
		for(int i=0x1;i<0x80;i++)
		{
			if (val[i])
			{
				print("0x");
				print_hex(i,2);
				print(" ");
			}
		}
		print("\n");
	} else 
	{
		print("no i2c devices found !!!");
	}
}

#define SPICR0		(0x08)
#define SPICR1		(0x09)
#define SPICR2		(0x0A)
#define SPIBR		(0x0B)
#define SPITXDR		(0x0D)
#define SPIRXDR		(0x0E)
#define SPICSR		(0x0F)
#define SPISR		(0x0C)
#define SPIINTSR	(0x06)
#define SPIINTCR	(0x07)

inline void spi_wait_trdy() 
{
	while((reg_spi[SPISR] & 0x10) == 0);
}

inline void spi_wait_rrdy() 
{
	while((reg_spi[SPISR] & 0x08) == 0);
}

void spi_init() 
{
	spi_wait_trdy();
	reg_spi[SPICR1] = 0x80;
	spi_wait_trdy();
	reg_spi[SPIBR] = 0x3f;
	spi_wait_trdy();
	reg_spi[SPICR2] = 0xC0;
}

void spi_deinit() 
{
	while((reg_spi[SPISR] & 0x80) != 0);
}

void spi_write(uint8_t data) 
{
	spi_wait_trdy();
	reg_spi[SPITXDR] = data;
	spi_wait_rrdy();
}

void spi_test() 
{
	spi_init();

	spi_write(0x01);
	spi_write(0x02);
	spi_write(0x03);
	spi_write(0x04);
	spi_deinit();
}

char getchar_prompt(char *prompt)
{
	int32_t c = -1;

	uint32_t cycles_begin, cycles_now, cycles;
	__asm__ volatile ("rdcycle %0" : "=r"(cycles_begin));

	if (prompt)
		print(prompt);

	while (c == -1) {
		__asm__ volatile ("rdcycle %0" : "=r"(cycles_now));
		cycles = cycles_now - cycles_begin;
		if (cycles > 12000000) {
			if (prompt)
				print(prompt);
			cycles_begin = cycles_now;
		}
		c = reg_uart_data;
	}
	return c;
}

char _getchar()
{
	return getchar_prompt(0);
}


// --------------------------------------------------------

inline int gpio(uint32_t pin)
{
	return (reg_gpio_data & pin);
}

const uint8_t _7_seg_mapping[10] = {
	0x7E, // '0'
	0x0A, // '1'    _a_
	0xB6, // '2'  f|   |b
	0x9E, // '3'   |_g_|
	0xCA, // '4'  e|   |c
	0xDC, // '5'   |_d_|.dp
	0xFC, // '6'
	0x0E, // '7'
	0xFE, // '8'
	0xDE // '9'
};

void wire_test()
{
	print("Start wire test\n");
			
	int error1 = 0;
	int error2 = 0;


	reg_gpio_data = 0; // write zero
	reg_gpio_mode = PIN_CS_1; // PIN OUT
	_delay_ms(20);
	reg_gpio_mode = 0; // PIN INPUT
	int retries1 = 0;
	int timeout1 = 0;
	while(gpio(PIN_CS_1)) 
	{
		retries1 += 2;
		if (retries1 > 60)
		{
			timeout1 = 1;
			break;
		}
	}
	int retries2 = 0;
	int timeout2 = 0;
	while(!gpio(PIN_CS_1)) 
	{
		retries2 += 2;
		if (retries2 > 100)
		{
			timeout2 = 1;
			break;
		}
	}
	int retries3 = 0;
	int timeout3 = 0;
	while(gpio(PIN_CS_1)) 
	{
		retries3 += 2;
		if (retries3 > 100)
		{
			timeout3 = 1;
			break;
		}
	}

	int e1 = 0,e2=0;
	int retries = 0;
	int tmap[40];
	for (int i = 0 ; i < 40 ; i++)
	{
		//There is always a leading low level of 50 us
		while(!gpio(PIN_CS_1)) {}
		retries = 0;
		while(gpio(PIN_CS_1))
		{
			retries++;
			if (retries & 0x40)
			{
				e1 = i;
				error2 = 1;
				i = 40;								//Break outer for-loop
				break;
			}
		}
		tmap[i] = retries;
	}
	uint8_t data[5];
	for (int i=0;i<5;i++)
	{
		data[i]=0;
		for (int j=0;j<8;j++)
		{
			data[i] = (data[i] << 1) | ((tmap[i*8+j]>=2) ? 1 :0);
		}
	}
	uint8_t check = data[0]+data[1]+data[2]+data[3];
	if (check==data[4])
	{
		print("DATA OK\n");
	} else {
		print("CHECKSUM ERROR\n");
	}
	uint16_t hum = data[0] *256 + data[1];
	uint16_t temp = data[2] *256+ data[3];
	print("Humidity : ");
	print_dec_ex(hum/10);
	print(".");
	print_dec_ex(hum%10);
	print("%%\n");
	print("Temperature : ");
	print_dec_ex(temp/10);
	print(".");
	print_dec_ex(temp%10);
	print("C\n");

	uint8_t hi = temp / 100;
	uint8_t lo = (temp / 10) % 10;

	reg_gpio_data = 0;
	reg_gpio_mode = PIN_RST_2 | PIN_CS_2; // PIN OUT

	spi_init();

	reg_gpio_data = PIN_RST_2;
	_delay_us(100);

	spi_write(_7_seg_mapping[lo]);
	spi_write(_7_seg_mapping[hi]);
	
	reg_gpio_data = PIN_RST_2 | 0;
	_delay_us(100);
	reg_gpio_data = PIN_RST_2 | PIN_CS_2;
	_delay_us(100);

	spi_deinit();
}

void ledring_test() 
{
	reg_gpio_data = 0;
	reg_gpio_mode = PIN_RST_2 | PIN_CS_2; // PIN OUT

	spi_init();

	reg_gpio_data = PIN_RST_2;
	_delay_ms(1);

	union {
		uint32_t val;
		uint8_t part[4];
	} t;
	t.val = 1;
	
	for (int i=0;i<32*5;i++)
	{
		spi_write(t.part[0]);
		spi_write(t.part[1]);
		spi_write(t.part[2]);
		spi_write(t.part[3]);
		
		t.val <<= 1;
		if (t.val == 0) t.val = 1;

		reg_gpio_data = PIN_RST_2 | 0;
		_delay_ms(1);
		reg_gpio_data = PIN_RST_2 | PIN_CS_2;
		_delay_ms(10);
	}

	spi_write(0);
	spi_write(0);
	spi_write(0);
	spi_write(0);
	reg_gpio_data = PIN_RST_2 | 0;
	_delay_ms(1);
	reg_gpio_data = PIN_RST_2 | PIN_CS_2;
	_delay_ms(10);

	_delay_ms(1);
	spi_deinit();
}

void _7seg_test() 
{
	reg_gpio_data = 0;
	reg_gpio_mode = PIN_RST_2 | PIN_CS_2; // PIN OUT

	spi_init();

	reg_gpio_data = PIN_RST_2;
	_delay_us(100);

	spi_write(0xb6);
	spi_write(0x0e);
	
	reg_gpio_data = PIN_RST_2 | 0;
	_delay_us(100);
	reg_gpio_data = PIN_RST_2 | PIN_CS_2;
	_delay_us(100);

	spi_deinit();
}

void _7x10_test() 
{
	reg_gpio_data = PIN_PWM_2;
	reg_gpio_mode = PIN_AN_2 | PIN_RST_2 | PIN_CS_2 | PIN_PWM_2; // PIN OUT

	spi_init();

	for (int j=0;j<100;j++)
	{
	for (int i=0;i<7;i++)
	{
		spi_write(0x11);
		spi_write(0x03);
		reg_gpio_data = PIN_RST_2 ;
		_delay_us(100);
		reg_gpio_data = PIN_RST_2 | PIN_AN_2;
		_delay_us(100);
		
		spi_write(0x11);
		spi_write(0x03);
		reg_gpio_data = PIN_RST_2 | 0;
		_delay_us(100);
		reg_gpio_data = PIN_RST_2 | PIN_AN_2;
		_delay_us(100);

		spi_write(0x11);
		spi_write(0x03);
		reg_gpio_data = PIN_RST_2 | 0 ;
		_delay_us(100);
		reg_gpio_data = PIN_RST_2 | PIN_AN_2;
		_delay_us(100);
	}
	}

	spi_deinit();
}
// --------------------------------------------------------
void main()
{
	reg_uart_clkdiv = 1250;
	//set_flash_qspi_flag();

	while (getchar_prompt("Press ENTER to continue..\n") != '\r') { /* wait */ }

	print("\n");
	print("  ____  _          ____         ____\n");
	print(" |  _ \\(_) ___ ___/ ___|  ___  / ___|\n");
	print(" | |_) | |/ __/ _ \\___ \\ / _ \\| |\n");
	print(" |  __/| | (_| (_) |__) | (_) | |___\n");
	print(" |_|   |_|\\___\\___/____/ \\___/ \\____|\n");
	print(" \n");
	print(" -------------MikroBUS board-------------\n");
	
	while (1)
	{
		print("\n");
		print("Select an action:\n");
		print("\n");
		print("   [1] Scan I2C on mikroBUS 1\n");
		print("   [2] Scan I2C on mikroBUS 2\n");
		print("   [S] Run SPI test\n");
		print("   [W] DHT-22 1-wire test (mikroBUS 1)\n");
		print("   [7] 7seg test (mikroBUS 2)\n");
		print("   [0] 7x10 R test (mikroBUS 2)\n");
		print("   [L] LED ring test (mikroBUS 2)\n");

		print("\n");

		for (int rep = 10; rep > 0; rep--)
		{
			print("Command> ");

			char cmd = _getchar();
			if (cmd > 32 && cmd < 127)
				putchar(cmd);
			print("\n");

			switch (cmd)
			{
			case '1':
				i2c_test(0x00);
				break;
			case '2':
				i2c_test(0x80 >> 2);
				break;
			case 'S':
				spi_test();
				break;
			case 'W':
				wire_test();
				break;
			case '7':
				_7seg_test();
				break;
			case '0':
				_7x10_test();
				break;
			case 'L':
				ledring_test();
				break;
			default:
				continue;
			}

			break;
		}
	}
}


EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:switches
LIBS:mikrobus-board-cache
EELAYER 25 0
EELAYER END
$Descr A3 16535 11693
encoding utf-8
Sheet 1 1
Title "MikroBus adapter for Hackaday Belgrade 2018"
Date ""
Rev "1.0"
Comp "Miodrag Milanovic"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Conn_01x18 UPDUINO2_UP1
U 1 1 5A7EF53F
P 6700 5500
F 0 "UPDUINO2_UP1" H 6700 6400 50  0000 C CNN
F 1 "Conn_01x18" H 6700 4500 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x18_Pitch2.54mm" H 6700 5500 50  0001 C CNN
F 3 "" H 6700 5500 50  0001 C CNN
	1    6700 5500
	1    0    0    -1  
$EndComp
$Comp
L Conn_01x16 UPDUINO2_DOWN1
U 1 1 5A7EF5F4
P 7350 5400
F 0 "UPDUINO2_DOWN1" H 7350 6200 50  0000 C CNN
F 1 "Conn_01x16" H 7350 4500 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x16_Pitch2.54mm" H 7350 5400 50  0001 C CNN
F 3 "" H 7350 5400 50  0001 C CNN
	1    7350 5400
	-1   0    0    -1  
$EndComp
$Comp
L +3.3V #PWR9
U 1 1 5A7F089C
P 8200 6300
F 0 "#PWR9" H 8200 6150 50  0001 C CNN
F 1 "+3.3V" H 8200 6440 50  0000 C CNN
F 2 "" H 8200 6300 50  0001 C CNN
F 3 "" H 8200 6300 50  0001 C CNN
	1    8200 6300
	0    1    1    0   
$EndComp
Text Label 5900 6300 0    60   ~ 0
OSC_OUT
Text Label 5900 4800 0    60   ~ 0
RST_1
Text Label 5900 4900 0    60   ~ 0
MOSI_1
Text Label 5900 5000 0    60   ~ 0
MISO_1
Text Label 5900 5100 0    60   ~ 0
SCK_1
Text Label 5900 5200 0    60   ~ 0
CS_1
Text Label 5900 5300 0    60   ~ 0
PWM_1
Text Label 5900 5400 0    60   ~ 0
INT_1
Text Label 5900 5500 0    60   ~ 0
RX_1
Text Label 5900 5600 0    60   ~ 0
TX_1
Text Label 5900 5700 0    60   ~ 0
SCL_1
Text Label 5900 5800 0    60   ~ 0
SDA_1
Text Label 5900 5900 0    60   ~ 0
EXT_1
Text Label 5900 6200 0    60   ~ 0
EXT_4
Text Label 5900 6100 0    60   ~ 0
EXT_3
Text Label 5900 6000 0    60   ~ 0
EXT_2
Text Label 5900 4700 0    60   ~ 0
AN_1
Text Label 7900 5600 0    60   ~ 0
INT_2
Text Label 7900 5400 0    60   ~ 0
PWM_2
Text Label 7900 6000 0    60   ~ 0
SDA_2
Text Label 7900 5900 0    60   ~ 0
SCL_2
Text Label 7900 5800 0    60   ~ 0
TX_2
Text Label 7900 5700 0    60   ~ 0
RX_2
Text Label 7900 4700 0    60   ~ 0
AN_2
Text Label 7900 5200 0    60   ~ 0
MOSI_2
Text Label 7900 5100 0    60   ~ 0
MISO_2
Text Label 7900 4800 0    60   ~ 0
RST_2
Text Label 7900 5500 0    60   ~ 0
OSC_OUT
Text Label 7900 5000 0    60   ~ 0
SCK_2
Text Label 7900 4900 0    60   ~ 0
CS_2
$Comp
L Conn_01x08 P3
U 1 1 5732DECF
P 3950 7500
F 0 "P3" H 3950 7950 50  0000 C CNN
F 1 "microBus_1" V 4050 7500 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x08_Pitch2.54mm" H 3950 7500 50  0001 C CNN
F 3 "" H 3950 7500 50  0000 C CNN
	1    3950 7500
	1    0    0    -1  
$EndComp
$Comp
L Conn_01x08 P4
U 1 1 5732E1C6
P 5050 7500
F 0 "P4" H 5050 7950 50  0000 C CNN
F 1 "microBus_2" V 5150 7500 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x08_Pitch2.54mm" H 5050 7500 50  0001 C CNN
F 3 "" H 5050 7500 50  0000 C CNN
	1    5050 7500
	1    0    0    -1  
$EndComp
Text Notes 3950 6900 0    120  ~ 0
mikroBus 1
Text Label 4450 7200 0    60   ~ 0
PWM_1
Text Label 4450 7400 0    60   ~ 0
RX_1
Text Label 4450 7500 0    60   ~ 0
TX_1
$Comp
L GND #PWR3
U 1 1 5732FDAE
P 4750 8000
F 0 "#PWR3" H 4750 7750 50  0001 C CNN
F 1 "GND" H 4750 7850 50  0000 C CNN
F 2 "" H 4750 8000 50  0000 C CNN
F 3 "" H 4750 8000 50  0000 C CNN
	1    4750 8000
	1    0    0    -1  
$EndComp
NoConn ~ 4850 7800
Text Label 3350 7200 0    60   ~ 0
AN_1
Text Label 4450 7600 0    60   ~ 0
SCL_1
Text Label 4450 7700 0    60   ~ 0
SDA_1
Text Label 3350 7400 0    60   ~ 0
CS_1
Text Label 3350 7500 0    60   ~ 0
SCK_1
Text Label 3350 7600 0    60   ~ 0
MISO_1
Text Label 3350 7700 0    60   ~ 0
MOSI_1
Text Label 4450 7300 0    60   ~ 0
INT_1
Text Label 3350 7300 0    60   ~ 0
RST_1
$Comp
L +3.3V #PWR1
U 1 1 5ABB8932
P 3350 7800
F 0 "#PWR1" H 3350 7650 50  0001 C CNN
F 1 "+3.3V" H 3350 7940 50  0000 C CNN
F 2 "" H 3350 7800 50  0001 C CNN
F 3 "" H 3350 7800 50  0001 C CNN
	1    3350 7800
	0    -1   -1   0   
$EndComp
$Comp
L Conn_01x08 P5
U 1 1 5ABB8B35
P 6400 7500
F 0 "P5" H 6400 7950 50  0000 C CNN
F 1 "microBus_1" V 6500 7500 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x08_Pitch2.54mm" H 6400 7500 50  0001 C CNN
F 3 "" H 6400 7500 50  0000 C CNN
	1    6400 7500
	1    0    0    -1  
$EndComp
$Comp
L Conn_01x08 P6
U 1 1 5ABB8B3B
P 7500 7500
F 0 "P6" H 7500 7950 50  0000 C CNN
F 1 "microBus_2" V 7600 7500 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x08_Pitch2.54mm" H 7500 7500 50  0001 C CNN
F 3 "" H 7500 7500 50  0000 C CNN
	1    7500 7500
	1    0    0    -1  
$EndComp
Text Notes 6400 6900 0    120  ~ 0
mikroBus 2
Text Label 6900 7200 0    60   ~ 0
PWM_2
Text Label 6900 7400 0    60   ~ 0
RX_2
Text Label 6900 7500 0    60   ~ 0
TX_2
$Comp
L GND #PWR6
U 1 1 5ABB8B45
P 6100 8000
F 0 "#PWR6" H 6100 7750 50  0001 C CNN
F 1 "GND" H 6100 7850 50  0000 C CNN
F 2 "" H 6100 8000 50  0000 C CNN
F 3 "" H 6100 8000 50  0000 C CNN
	1    6100 8000
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR7
U 1 1 5ABB8B4B
P 7200 8000
F 0 "#PWR7" H 7200 7750 50  0001 C CNN
F 1 "GND" H 7200 7850 50  0000 C CNN
F 2 "" H 7200 8000 50  0000 C CNN
F 3 "" H 7200 8000 50  0000 C CNN
	1    7200 8000
	1    0    0    -1  
$EndComp
NoConn ~ 7300 7800
Text Label 5800 7200 0    60   ~ 0
AN_2
Text Label 6900 7600 0    60   ~ 0
SCL_2
Text Label 6900 7700 0    60   ~ 0
SDA_2
Text Label 5800 7400 0    60   ~ 0
CS_2
Text Label 5800 7500 0    60   ~ 0
SCK_2
Text Label 5800 7600 0    60   ~ 0
MISO_2
Text Label 5800 7700 0    60   ~ 0
MOSI_2
Text Label 6900 7300 0    60   ~ 0
INT_2
Text Label 5800 7300 0    60   ~ 0
RST_2
NoConn ~ 7550 5300
Text Label 8950 7150 0    60   ~ 0
EXT_4
Text Label 8950 7250 0    60   ~ 0
EXT_3
Text Label 8950 7350 0    60   ~ 0
EXT_2
Text Label 8950 7450 0    60   ~ 0
EXT_1
$Comp
L GND #PWR5
U 1 1 5ABB9FEC
P 5950 6450
F 0 "#PWR5" H 5950 6200 50  0001 C CNN
F 1 "GND" H 5950 6300 50  0000 C CNN
F 2 "" H 5950 6450 50  0001 C CNN
F 3 "" H 5950 6450 50  0001 C CNN
	1    5950 6450
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR4
U 1 1 5ABBA05D
P 5850 7800
F 0 "#PWR4" H 5850 7650 50  0001 C CNN
F 1 "+3.3V" H 5850 7940 50  0000 C CNN
F 2 "" H 5850 7800 50  0001 C CNN
F 3 "" H 5850 7800 50  0001 C CNN
	1    5850 7800
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7550 4800 7900 4800
Wire Wire Line
	7550 4900 7900 4900
Wire Wire Line
	7550 5000 7900 5000
Wire Wire Line
	7550 5100 7900 5100
Wire Wire Line
	7550 5200 7900 5200
Wire Wire Line
	7550 6200 8200 6200
Wire Wire Line
	8200 6200 8200 6300
Wire Wire Line
	5900 6300 6500 6300
Wire Wire Line
	5900 5900 6500 5900
Wire Wire Line
	5900 5800 6500 5800
Wire Wire Line
	5900 5700 6500 5700
Wire Wire Line
	5900 5600 6500 5600
Wire Wire Line
	5900 5500 6500 5500
Wire Wire Line
	5900 5400 6500 5400
Wire Wire Line
	5900 5300 6500 5300
Wire Wire Line
	5900 5200 6500 5200
Wire Wire Line
	5900 5100 6500 5100
Wire Wire Line
	5900 5000 6500 5000
Wire Wire Line
	5900 4900 6500 4900
Wire Wire Line
	5900 4800 6500 4800
Wire Wire Line
	5900 4700 6500 4700
Wire Wire Line
	5900 6000 6500 6000
Wire Wire Line
	5900 6100 6500 6100
Wire Wire Line
	5900 6200 6500 6200
Wire Wire Line
	7900 5600 7550 5600
Wire Wire Line
	7900 5400 7550 5400
Wire Wire Line
	7900 6000 7550 6000
Wire Wire Line
	7900 5900 7550 5900
Wire Wire Line
	7900 5800 7550 5800
Wire Wire Line
	7900 5700 7550 5700
Wire Wire Line
	7900 4700 7550 4700
Wire Wire Line
	7900 5500 7550 5500
Wire Wire Line
	3750 7200 3350 7200
Wire Wire Line
	3350 7300 3750 7300
Wire Wire Line
	3750 7400 3350 7400
Wire Wire Line
	3750 7500 3350 7500
Wire Wire Line
	3750 7600 3350 7600
Wire Wire Line
	3750 7700 3350 7700
Wire Wire Line
	3750 7900 3650 7900
Wire Wire Line
	4850 7200 4450 7200
Wire Wire Line
	4450 7300 4850 7300
Wire Wire Line
	4850 7400 4450 7400
Wire Wire Line
	4450 7500 4850 7500
Wire Wire Line
	4850 7600 4450 7600
Wire Wire Line
	4850 7900 4750 7900
Wire Wire Line
	4750 7900 4750 8000
Wire Wire Line
	4450 7700 4850 7700
Wire Wire Line
	3350 7800 3750 7800
Wire Wire Line
	6200 7200 5800 7200
Wire Wire Line
	5800 7300 6200 7300
Wire Wire Line
	6200 7400 5800 7400
Wire Wire Line
	6200 7500 5800 7500
Wire Wire Line
	6200 7600 5800 7600
Wire Wire Line
	6200 7700 5800 7700
Wire Wire Line
	6200 7900 6100 7900
Wire Wire Line
	7300 7200 6900 7200
Wire Wire Line
	6900 7300 7300 7300
Wire Wire Line
	7300 7400 6900 7400
Wire Wire Line
	6900 7500 7300 7500
Wire Wire Line
	7300 7600 6900 7600
Wire Wire Line
	7300 7900 7200 7900
Wire Wire Line
	7200 7900 7200 8000
Wire Wire Line
	6100 7900 6100 8000
Wire Wire Line
	6900 7700 7300 7700
Wire Wire Line
	8950 7150 9450 7150
Wire Wire Line
	8950 7250 9450 7250
Wire Wire Line
	8950 7350 9450 7350
Wire Wire Line
	8950 7450 9450 7450
Wire Wire Line
	5950 6450 5950 6400
Wire Wire Line
	5950 6400 6500 6400
Wire Wire Line
	5850 7800 6200 7800
$Comp
L GND #PWR2
U 1 1 5ABBA17A
P 3650 7900
F 0 "#PWR2" H 3650 7650 50  0001 C CNN
F 1 "GND" H 3650 7750 50  0000 C CNN
F 2 "" H 3650 7900 50  0001 C CNN
F 3 "" H 3650 7900 50  0001 C CNN
	1    3650 7900
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR8
U 1 1 5ABBA41C
P 8150 6100
F 0 "#PWR8" H 8150 5850 50  0001 C CNN
F 1 "GND" H 8150 5950 50  0000 C CNN
F 2 "" H 8150 6100 50  0001 C CNN
F 3 "" H 8150 6100 50  0001 C CNN
	1    8150 6100
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7550 6100 8150 6100
$Comp
L Conn_01x06 J1
U 1 1 5ABB93C6
P 9650 7350
F 0 "J1" H 9650 7650 50  0000 C CNN
F 1 "Conn_01x06" H 9650 6950 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x06_Pitch2.54mm" H 9650 7350 50  0001 C CNN
F 3 "" H 9650 7350 50  0001 C CNN
	1    9650 7350
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR10
U 1 1 5ABB93FE
P 9150 7550
F 0 "#PWR10" H 9150 7400 50  0001 C CNN
F 1 "+3.3V" H 9150 7690 50  0000 C CNN
F 2 "" H 9150 7550 50  0001 C CNN
F 3 "" H 9150 7550 50  0001 C CNN
	1    9150 7550
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR11
U 1 1 5ABB9420
P 9150 7650
F 0 "#PWR11" H 9150 7400 50  0001 C CNN
F 1 "GND" H 9150 7500 50  0000 C CNN
F 2 "" H 9150 7650 50  0001 C CNN
F 3 "" H 9150 7650 50  0001 C CNN
	1    9150 7650
	0    1    1    0   
$EndComp
Wire Wire Line
	9150 7650 9450 7650
Wire Wire Line
	9150 7550 9450 7550
$EndSCHEMATC

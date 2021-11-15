#define GREEN_LED_PORT ((int*)0x40020c00)
#define GREEN_LED_PIN  ((int)0x00001000)
#define RCC_PORT       ((int*)0x40023800)

void init_gpio()
{
  int position = 12;
  int* dest = 0;
  /* Configure IO Direction mode (Output) (GREEN LED) */
  dest = GREEN_LED_PORT;
  *dest |= (1 << (position * 2));
}

//Debug Exception and Monitor Control Register base address
#define DEMCR *((volatile int*) 0xE000EDFC)
/* ITM register addresses */
#define ITM_STIMULUS_PORT0_u8  	*((volatile char*) 0xE0000000)
#define ITM_TRACE_EN          	*((volatile int*) 0xE0000E00)
void ITM_SendChar(char ch)
{
	//Enable TRCENA
	DEMCR |= ( 1 << 24);
	//enable stimulus port 0
	ITM_TRACE_EN |= ( 1 << 0);
	// read FIFO status in bit [0]:
	while(!(ITM_STIMULUS_PORT0_u8 & 1));
	//Write to ITM stimulus port0
	ITM_STIMULUS_PORT0_u8 = ch;
}

int main()
{
  char str[25] = "james\n";
  for (int i = 0; i < 25; i++)
    ITM_SendChar(str[i]);

  // enable clock
  int* rcc_port = RCC_PORT;
  rcc_port += 0x30 / 4; // offset
  *rcc_port |= 0x1 << 3;

  init_gpio();

  int* led_port = GREEN_LED_PORT;
  led_port += 0x18 / 4; // offset

  char flag = 0;
  while(1)
  {
    *led_port |= (1 << 12) << 16*flag;
    for (int i = 0; i < (int)1e8; i++);
    flag = 1 - flag;
  }

  return 0;
}


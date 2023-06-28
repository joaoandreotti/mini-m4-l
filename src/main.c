#define GREEN_LED_PORT ((int*)0x40020c00)
#define GREEN_LED_PIN  ((int)0x00001000)
#define RCC_PORT       ((int*)0x40023800)

int james = 34563;
char carolina;

void init_gpio()
{
  int position = 12;
  int* dest = 0;
  /* Configure IO Direction mode (Output) (GREEN LED) */
  dest = GREEN_LED_PORT;
  *dest |= (1 << (position * 2));
}

int main()
{
  // enable clock
  int* rcc_port = RCC_PORT;
  rcc_port += 0x30 / 4; // offset
  *rcc_port |= 0x1 << 3;

  init_gpio();

  int* led_port = GREEN_LED_PORT;
  led_port += 0x18 / 4; // offset

  carolina = 1;
  char flag = 1;
  while(1)
  {
    *led_port |= (1 << 12) << 16*flag;
    for (int i = 0; i < (int)1e6; i++);
    flag = 1 - flag;
  }

  return 0;
}

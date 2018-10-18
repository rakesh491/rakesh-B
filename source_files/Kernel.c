#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <printer.h>
#define VGA_VRAM 0xa0000
#define PITCH 320
extern void enable_paging(void* PD_address);

void kernel_main(void){
  char* string = (char*) 0x00006000;
  print32_hex(string,(0xb80a0+0xa0));

  for(;;);
}

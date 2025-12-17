#include "aes/aes.h"
#include <stdio.h>
#include <string.h>


#define NUM_BLKS (2)


void print_text(char *prefix, unsigned char *text) {
  printf("%s", prefix);
  for (int i = 0; i < 16; i++) {
    printf("%02x ", text[i]);
  }
  printf("   ");
  for (int i = 0; i < 16; i++) {
    if (text[i] >= 32 && text[i] <= 126) {
      printf("%c", text[i]);
    } else {
      printf(".");
    }
  }
  printf("\n");
}


int main() {
  unsigned char key[32] = {0x60, 0x3d, 0xeb, 0x10, 0x15, 0xca, 0x71, 0xbe, 0x2b, 0x73, 0xae, 0xf0, 0x85, 0x7d, 0x77, 0x81,
                           0x1f, 0x35, 0x2c, 0x07, 0x3b, 0x61, 0x08, 0xd7, 0x2d, 0x98, 0x10, 0xa3, 0x09, 0x14, 0xdf, 0xf4};
  unsigned char expanded_key[240];
  aes256_key_expansion(key, expanded_key);

  return 0;
}
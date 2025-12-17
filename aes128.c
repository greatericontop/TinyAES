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
  unsigned char key[16];
  memcpy(key, "abcdefghHGFEDCBA", 16);
  unsigned char plaintext[16*NUM_BLKS];
  memcpy(plaintext,
         "test message",
         16*NUM_BLKS);
  unsigned char ciphertext[16*NUM_BLKS];
  unsigned char newplaintext[16*NUM_BLKS];

  for (int i = 0; i < NUM_BLKS; i++) {
    print_text(i == 0 ? "plaintext   " : "            ", plaintext + 16*i);
  }
  printf("\n");

  for (int i = 0; i < NUM_BLKS; i++) {
    // ECB is not very secure
    aes128_enc(plaintext + 16*i, ciphertext + 16*i, key);
    print_text(i == 0 ? "ciphertext  " : "            ", ciphertext + 16*i);
  }
  printf("\n");

  for (int i = 0; i < NUM_BLKS; i++) {
    aes128_dec(ciphertext + 16*i, newplaintext + 16*i, key);
    print_text(i == 0 ? "decrypted   " : "            ", newplaintext + 16*i);
  }

  return 0;
}
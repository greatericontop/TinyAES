#include "aes/aes.h"
#include <stdio.h>
#include <string.h>


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

  unsigned char plaintext[16];
  unsigned char ciphertext[16];
  memcpy(plaintext, "aaaaaaaaaaaaaaa", 16);
  print_text("Plaintext:  ", plaintext);
  aes256_enc(plaintext, ciphertext, expanded_key);
  print_text("Ciphertext: ", ciphertext);
  unsigned char decrypted[16];
  aes256_dec(ciphertext, decrypted, expanded_key);
  print_text("Decrypted:  ", decrypted);

  unsigned char ciphertext2[16] = {0x82, 0x9b, 0x10, 0xd3, 0x32, 0x0a, 0x1a, 0x51, 0x3f, 0x8e, 0x49, 0x36, 0x58, 0x89, 0x61, 0x12};
  aes256_dec(ciphertext2, decrypted, expanded_key);
  print_text("Decrypted2: ", decrypted);

  return 0;
}
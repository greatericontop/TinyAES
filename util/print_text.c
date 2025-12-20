#pragma once


#include <stdio.h>


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

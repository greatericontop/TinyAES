#include "fastxor.h"
#include <assert.h>
#include <stdio.h>


void print_text(char *prefix, unsigned char *text) {
  printf("%s", prefix);
  for (int i = 0; i < 16; i++) {
    printf("%08b ", text[i]);
  }
  printf("\n");
}


int main() {
  FILE *fp = fopen("/dev/urandom", "rb");
  assert(fp);
  unsigned char a[16], b[16], result[16];
  fread(a, 1, 16, fp);
  fread(b, 1, 16, fp);
  fastxor(a, b, result);
  print_text("a:       ", a);
  print_text("b:       ", b);
  print_text("a xor b: ", result);
  fclose(fp);
  return 0;
}
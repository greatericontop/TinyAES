#include "aes/aes.h"
#include "util/fastxor.h"
#include "util/print_text.c"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


/*
 * Encrypt the given :plaintext: of length :blocks: 16-byte blocks, and store
 * the result in :ciphertext:.
 * Uses CBC mode, using the given :iv: (16-byte initialization vector).
 * The :key: is fed into the :enc_callback: (which should be either aes128_enc
 * or aes256_enc).
 * Output format: IV || ciphertext blocks
 */
void cbc_encrypt(const unsigned char *plaintext, int blocks,
                 unsigned char *ciphertext,
                 const unsigned char *iv,
                 const unsigned char *key,
                 void (*enc_callback)(const unsigned char *pt, unsigned char *ct, const unsigned char *k)) {
  memcpy(ciphertext, iv, 16);
  for (int i = 0; i < blocks; i++) {
    fastxor(plaintext + 16*i, ciphertext + 16*i, ciphertext + 16*(i+1));
    enc_callback(ciphertext + 16*(i+1), ciphertext + 16*(i+1), key);
  }
}


/*
 * Decrypt the given :ciphertext: of length :blocks: 16-byte blocks, and store
 * the result in :plaintext: (:plaintext: must be size :blocks-1: 16-byte
 * blocks, as the first "block" of ciphertext is IV.
 */
void cbc_decrypt(const unsigned char *ciphertext, int blocks,
                 unsigned char *plaintext,
                 const unsigned char *key,
                 void (*dec_callback)(const unsigned char *ct, unsigned char *pt, const unsigned char *k)) {
  for (int i = 1; i < blocks; i++) {
    dec_callback(ciphertext + 16*i, plaintext + 16*(i-1), key);
    fastxor(plaintext + 16*(i-1), ciphertext + 16*(i-1), plaintext + 16*(i-1));
  }
}


#define PT_SZ (80)
#define CT_SZ (96)


int main() {
  unsigned char key[32], expanded_key[240], iv[16], plaintext[PT_SZ], ciphertext[CT_SZ], decrypted[PT_SZ];
  FILE *fp = fopen("/dev/urandom", "rb");
  fread(key, 1, 32, fp);
  fread(iv, 1, 16, fp);
  memset(plaintext, 0x67, PT_SZ);
  //fread(plaintext, 1, PT_SZ, fp);
  fclose(fp);
  aes256_key_expansion(key, expanded_key);

  for (int i = 0; i < PT_SZ; i += 16) {
    print_text("Plaintext:    ", plaintext+i);
  }
  printf("\n");
  cbc_encrypt(plaintext, PT_SZ/16, ciphertext, iv, expanded_key, &aes256_enc);
  for (int i = 0; i < CT_SZ; i += 16) {
    print_text("Ciphertext:   ", ciphertext+i);
  }
  printf("\n");
  cbc_decrypt(ciphertext, CT_SZ/16, decrypted, expanded_key, &aes256_dec);
  for (int i = 0; i < PT_SZ; i += 16) {
    print_text("Decrypted:    ", decrypted+i);
  }

  return 0;
}
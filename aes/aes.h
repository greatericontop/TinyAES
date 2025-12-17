#pragma once


/* Encrypts plaintext with the key, result stored in ciphertext */
extern void aes128_enc(const unsigned char *plaintext,
                       unsigned char *ciphertext,
                       const unsigned char *key);

/* Decrypts ciphertext with the key, result stored in plaintext */
extern void aes128_dec(const unsigned char *ciphertext,
                       unsigned char *plaintext,
                       const unsigned char *key);

extern void aes256_enc(const unsigned char *plaintext,
                       unsigned char *ciphertext,
                       const unsigned char *key);

extern void aes256_dec(const unsigned char *ciphertext,
                       unsigned char *plaintext,
                       const unsigned char *key);
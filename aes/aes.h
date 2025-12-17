#pragma once


/*
 * No AES-128 key expansion function, it gets computed on the fly because I
 * didn't realize it might've been easier to have a separate function for it.
 */

/* Encrypts plaintext with the key, result stored in ciphertext */
extern void aes128_enc(const unsigned char *plaintext,
                       unsigned char *ciphertext,
                       const unsigned char *key);

/* Decrypts ciphertext with the key, result stored in plaintext */
extern void aes128_dec(const unsigned char *ciphertext,
                       unsigned char *plaintext,
                       const unsigned char *key);

/*
 * Expands the 256-bit cipher key into the expanded key
 * :expanded_key: must be able to hold 240 bytes (15 rounds * 16 bytes)
 */
extern void aes256_key_expansion(const unsigned char *key,
                                 unsigned char *expanded_key);

extern void aes256_enc(const unsigned char *plaintext,
                       unsigned char *ciphertext,
                       const unsigned char *key);

extern void aes256_dec(const unsigned char *ciphertext,
                       unsigned char *plaintext,
                       const unsigned char *key);
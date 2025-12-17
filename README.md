# TinyAES

TinyAES is an implementation of AES-128 and AES-256 in C/Assembly.
It uses Intel's AES-NI instructions, so it may not be compatible with unsupported (older) CPUs.

I made this to learn some assembly programming and some cryptography/AES internals.

> Disclaimer:
> Don't use my code in actual security systems!
> You should probably use a library with a better reputation, like OpenSSL.

## Compiling

`aes/aes.h` contains the function prototypes.
Compile with `aes/aes128.s` and `aes/aes256.s` for the actual implementations.
The provided `.c` files are demos/examples only and aren't necessary.

Example compilation command:

```bash
$ gcc -o my_program my_program.c aeslib/aes/aes128.s aeslib/aes/aes256.s
```

## Usage

### AES-128

```c
void aes128_enc(const unsigned char *plaintext,
                unsigned char *ciphertext,
                const unsigned char *key);

void aes128_dec(const unsigned char *ciphertext,
                unsigned char *plaintext,
                const unsigned char *key);
```

These functions encrypt/decrypt a single 16-byte block.
You pass in a pointer to the input data (a 16-byte `unsigned char` array), and the function writes the output to the provided pointer.
The function reads the key from the provided pointer (also a 16-byte array).

Example:

```c
unsigned char key[16] = {0x87, 0x24, 0x1f, 0xe3, ...};
unsigned char plaintext[16] = {0x20, 0x31, 0xe0, 0xf5, ...};
unsigned char ciphertext[16];
unsigned char decrypted[16];
aes128_enc(plaintext, ciphertext, key);
aes128_dec(ciphertext, decrypted, key);
```

You can also look at `aes128.c` for another example.

### AES-256

AES-256's usage requires you to call the key expansion function first. (I realized I should probably put that in a different function after I wrote the AES-128 key expansion twice...)

```c
void aes256_key_expansion(const unsigned char *key,
                          unsigned char *expanded_key);
```

This function performs the key expansion for AES-256.
It takes a pointer to the 256-bit cipher key (a 32-byte array) and writes the expanded key to the provided pointer (a 240-byte array - make sure you have allocated enough space).

Then encryption and decryption are the same, except that you pass in a pointer to the expanded key instead of the original key:

```c
void aes256_enc(const unsigned char *plaintext,
                unsigned char *ciphertext,
                const unsigned char *expanded_key);

void aes256_dec(const unsigned char *ciphertext,
                unsigned char *plaintext,
                const unsigned char *expanded_key);
```

You can look at `aes256.c` for an example.

## In-depth explanation of the code

[AES-128 explanation](https://github.com/greatericontop/TinyAES/blob/main/AES128EXPLANATION.md)
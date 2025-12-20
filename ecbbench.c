#include "aes/aes.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>


#define DATA_SIZE 1073741824 // 1 GiB


unsigned long long perf_counter_ns(void) {
    struct timespec mytimespec;
    clock_gettime(CLOCK_MONOTONIC, &mytimespec);
    return ((unsigned long long) mytimespec.tv_sec) * 1000000000ULL + mytimespec.tv_nsec;
}


void populate_with_random_bytes(unsigned char *ptr, int size) {
  FILE *fp = fopen("/dev/urandom", "rb");
  assert(fp);
  fread(ptr, 1, size, fp);
  fclose(fp);
}


void bench128() {
  printf("Generating random data...\n");
  unsigned char key[16];
  populate_with_random_bytes(key, 16);
  unsigned char *data = malloc(DATA_SIZE);
  assert(data);
  populate_with_random_bytes(data, DATA_SIZE);
  printf("Benchmarking... (bad comparison due to my 128 code recalculating key schedule every block)\n");
  unsigned long long start = perf_counter_ns();
  for (int i = 0; i < DATA_SIZE; i += 16) {
    aes128_enc(&data[i], &data[i], key);
  }
  unsigned long long end = perf_counter_ns();
  double mib_per_sec = ((double) DATA_SIZE) / 1048576.0 * 1e9 / ((double) (end - start));
  printf("AES128 Encryption: %'.1f MiB/s\n", mib_per_sec);
  start = perf_counter_ns();
  for (int i = 0; i < DATA_SIZE; i += 16) {
    aes128_dec(&data[i], &data[i], key);
  }
  end = perf_counter_ns();
  mib_per_sec = ((double) DATA_SIZE) / 1048576.0 * 1e9 / ((double) (end - start));
  printf("AES128 Decryption: %'.1f MiB/s\n", mib_per_sec);
  free(data);
}


void bench256() {
  printf("Generating random data...\n");
  unsigned char key[32];
  populate_with_random_bytes(key, 32);
  unsigned char expanded_key[240];
  aes256_key_expansion(key, expanded_key);
  unsigned char *data = malloc(DATA_SIZE);
  assert(data);
  populate_with_random_bytes(data, DATA_SIZE);
  printf("Benchmarking...\n");
  unsigned long long start = perf_counter_ns();
  for (int i = 0; i < DATA_SIZE; i += 16) {
    aes256_enc(&data[i], &data[i], expanded_key);
  }
  unsigned long long end = perf_counter_ns();
  double mib_per_sec = ((double) DATA_SIZE) / 1048576.0 * 1e9 / ((double) (end - start));
  printf("AES256 Encryption: %'.1f MiB/s\n", mib_per_sec);
  start = perf_counter_ns();
  for (int i = 0; i < DATA_SIZE; i += 16) {
    aes256_dec(&data[i], &data[i], expanded_key);
  }
  end = perf_counter_ns();
  mib_per_sec = ((double) DATA_SIZE) / 1048576.0 * 1e9 / ((double) (end - start));
  printf("AES256 Decryption: %'.1f MiB/s\n", mib_per_sec);
  free(data);
}


int main() {
  bench128();
  bench256();
  bench256();
  return 0;
}
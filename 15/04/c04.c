#include <openssl/evp.h>
#include <stdio.h>

#define SEED_LEN 8
#define MAX_DIGIT 9

int main() {
  EVP_MD_CTX *mdctx, *mdctx_copy;
  const EVP_MD *md;
  unsigned char md_value[EVP_MAX_MD_SIZE];
  unsigned int md_len;
  unsigned char seed[] = "iwrupvqb";
  char num_str[MAX_DIGIT + 1];
  unsigned int lower_bound = 1;
  // 1. Setup
  md = EVP_md5(); // Select MD5
  mdctx = EVP_MD_CTX_new();
  mdctx_copy = EVP_MD_CTX_new(); // Allocate the copy

  EVP_DigestInit_ex(mdctx, md, NULL);
  EVP_DigestUpdate(mdctx, seed, SEED_LEN); // Input string and length

  for (int digit = 1; digit <= MAX_DIGIT; digit++) {
    printf("scanning numbers from 10e%d to 10e%d...\n", digit, digit + 1);
    for (int num = lower_bound; num < lower_bound * 10; num++) {
      EVP_MD_CTX_copy_ex(mdctx_copy, mdctx);

      int len = snprintf(num_str, sizeof(num_str), "%d", num);
      if (len != digit)
        return -1;

      EVP_DigestUpdate(mdctx_copy, num_str, len); // Input string and length

      EVP_DigestFinal_ex(mdctx_copy, md_value, &md_len);
      // unsigned char zeroes = md_value[0] | md_value[1] | (md_value[2] &
      // 0xF0);
      unsigned char zeroes = md_value[0] | md_value[1] | md_value[2];
      if (zeroes == 0) {
        printf("Found num: \t%d\n", num);
        goto loop_break;
      }
    }
    lower_bound *= 10;
  };
loop_break:
  EVP_MD_CTX_free(mdctx);
  EVP_MD_CTX_free(mdctx_copy);
  return 0;
}

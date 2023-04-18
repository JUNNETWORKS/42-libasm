/*
テスト
*/

#include <assert.h>
#include <stdio.h>
#include <string.h>
#include "main.h"

static void test_ft_strlen();
static void test_ft_strcpy();

int main(int argc, char **argv) {
  test_ft_strlen();
  test_ft_strcpy();
}

static void test_ft_strlen() {
  printf("\n\n\n\n========== ft_strlen ==========\n");

  printf("empty: %zu\n", ft_strlen(""));
  assert(ft_strlen("") == 0);
  printf("hello: %zu\n", ft_strlen("hello"));
  assert(ft_strlen("hello") == 5);
}

static void test_ft_strcpy() {
  printf("\n\n\n\n========== ft_strcpy ==========\n");
  {
    char dst[256];
    const char *src = "";
    ft_strcpy(dst, src);
    assert(strcmp(dst, src) == 0);
    printf("Empty String OK\n");
  }
  {
    char dst[256];
    const char *src = "Hello World!";
    ft_strcpy(dst, src);
    assert(strcmp(dst, src) == 0);
    printf("Hello World OK\n");
  }
}
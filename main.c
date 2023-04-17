/*
テスト
*/

#include <assert.h>
#include <stdio.h>
#include "main.h"

static void test_ft_strlen();

int main(int argc, char **argv) {
  test_ft_strlen();
}

static void test_ft_strlen() {
  printf("empty: %zu\n", ft_strlen(""));
  assert(ft_strlen("") == 0);
  assert(ft_strlen("hello") == 5);
}
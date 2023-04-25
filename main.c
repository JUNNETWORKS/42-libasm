/*
テスト
*/

#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/errno.h>
#include "main.h"

static void test_ft_strlen();
static void test_ft_strcpy();
static void test_ft_strcmp();
static void test_ft_read();
static void test_ft_write();
static void test_ft_strdup();

int main(int argc, char **argv) {
  test_ft_strlen();
  test_ft_strcpy();
  test_ft_strcmp();
  test_ft_read();
  test_ft_write();
  test_ft_strdup();
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

static void test_ft_strcmp() {
  printf("\n\n\n\n========== ft_strcmp ==========\n");
  {
    const char *s1 = "";
    const char *s2 = "";
    assert(ft_strcmp(s1, s2) == 0);
    printf("empty OK\n");
  }
  {
    const char *s1 = "1";
    const char *s2 = "2";
    assert(ft_strcmp(s1, s2) < 0);
    printf("1 2 OK\n");
  }
  {
    const char *s1 = "2";
    const char *s2 = "1";
    assert(ft_strcmp(s1, s2) > 0);
    printf("2 1 OK\n");
  }
  {
    const char *s1 = "hello";
    const char *s2 = "hallo";
    assert(ft_strcmp(s1, s2) > 0);
    printf("h{e, a}llo OK\n");
  }
  {
    const char *s1 = "hello2";
    const char *s2 = "hello";
    assert(ft_strcmp(s1, s2) > 0);
    printf("hello2 OK\n");
  }
}

static void test_ft_read() {
  printf("\n\n\n\n========== ft_read ==========\n");

}

static void test_ft_write() {
  printf("\n\n\n\n========== ft_write ==========\n");

  const char *s = "Hello from test_ft_write()\n";
  int len = ft_write(1, s, strlen(s));
  assert(len == strlen(s));
  len = ft_write(1, "", 0);
  assert(len == 0);

  // Error
  len = ft_write(-1, "", 0);
  printf("Error case\n");
  printf("len: %d\n", len);
  assert(len == -1);
  assert(errno == EBADF);
}

static void test_ft_strdup() {
  printf("\n\n\n\n========== ft_strdup ==========\n");
}
/*
テスト
*/

#include <limits.h>
#include <unistd.h>
#include <sys/fcntl.h>
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

static void test_ft_atoi_base();
static void test_ft_list_push_front();
static void test_ft_list_size();
static void test_ft_list_sort();
static void test_ft_list_remove_if();

int main(int argc, char **argv) {
  test_ft_strlen();
  test_ft_strcpy();
  test_ft_strcmp();
  test_ft_read();
  test_ft_write();
  test_ft_strdup();

  // bonus
  test_ft_atoi_base();
  test_ft_list_push_front();
  test_ft_list_size();
  test_ft_list_sort();
  test_ft_list_remove_if();
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

  {
    char buf[256];
    char buf_ft[256];

    int fd = open("main.c", O_RDONLY);
    int res_ft = ft_read(fd, buf_ft, 255);
    buf_ft[res_ft] = '\0';

    lseek(fd, 0, SEEK_SET);

    int res = read(fd, buf, 255);
    buf[res] = '\0';

    assert(strcmp(buf_ft, buf) == 0);
    close(fd);
  }

  {
    char buf_ft[256];
    // Error
    int len = ft_read(-1, buf_ft, 255);
    assert(len == -1);
    assert(errno == EBADF);
  }
}

static void test_ft_write() {
  printf("\n\n\n\n========== ft_write ==========\n");

  const char *s = "Hello from test_ft_write()\n";
  int len = ft_write(1, s, strlen(s));
  assert(len == strlen(s));
  len = ft_write(1, "", 0);
  assert(len == 0);

  // Error
  printf("Error case\n");
  len = ft_write(-1, "", 0);
  printf("len: %d\n", len);
  assert(len == -1);
  assert(errno == EBADF);
}

static void test_ft_strdup() {
  printf("\n\n\n\n========== ft_strdup ==========\n");

  {
    const char *s = "This is a great text2.";
    const char *exp = ft_strdup(s);
    const char *ans = strdup(s);
    assert(strcmp(exp, ans) == 0);
    free((void *)exp);
    free((void *)ans);
  }
}

static void test_ft_atoi_base() {
  printf("\n\n\n\n========== ft_atoi_base ==========\n");

  // all printf are for debug
  int res = ft_atoi_base("	+++++--133742", "0123456789");
	printf("%d\n", res);
	// printf("%d\n", ft_atoi_base("	+++++--133742", "0123456789"));
	printf("%d\n", ft_atoi_base("	++++133742", "0123456789"));
	printf("%d\n", ft_atoi_base("	133742", "0123456789"));
	printf("%d\n", ft_atoi_base("	     ---101010", "01"));
	printf("%d\n", ft_atoi_base("	     101010", "01"));
	printf("%d\n", ft_atoi_base(" 	+---539", "0123456789abcdef"));
	printf("%d\n", ft_atoi_base(" 	+539", "0123456789abcdef"));
	printf("%d\n", ft_atoi_base(" 	539", "0123456789abcdef"));
	printf("%d\n", ft_atoi_base("     ", "0123456789abcdef"));

	assert(-133742 == ft_atoi_base("	+++++--133742", "0123456789"));
	assert(133742 == ft_atoi_base("	++++133742", "0123456789"));
	assert(133742 == ft_atoi_base("	133742", "0123456789"));
	assert(133742 == ft_atoi_base("	133742 133742", "0123456789"));
	assert(-42 == ft_atoi_base("	     ---101010", "01"));
	assert(42 == ft_atoi_base("	     101010", "01"));
	assert(-1337 == ft_atoi_base(" 	+---539", "0123456789abcdef"));
	assert(1337 == ft_atoi_base(" 	+539", "0123456789abcdef"));
	assert(1337 == ft_atoi_base(" 	539", "0123456789abcdef"));
	assert(0 == ft_atoi_base("     ", "0123456789abcdef"));
	assert(0 == ft_atoi_base("", "0123456789abcdef"));
	assert(0 == ft_atoi_base(NULL, "0123456789abcdef"));
	assert(0 == ft_atoi_base("00", "0"));
	assert(0 == ft_atoi_base("00", NULL));

  // overflow and undeflow tests
  printf("----- overflow and undeflow tests -----\n");
	printf("%d\n", ft_atoi_base("	+++++2147483647", "0123456789"));
	printf("%d\n", ft_atoi_base("	+++++2147483648", "0123456789"));  // overflow
	printf("%d\n", ft_atoi_base("	+++++--2147483648", "0123456789"));
	printf("%d\n", ft_atoi_base("	+++++--2147483649", "0123456789"));  // underflow

	assert(2147483647 == ft_atoi_base("	+++++2147483647", "0123456789"));
	assert(0 == ft_atoi_base("	+++++2147483648", "0123456789"));  // overflow
	assert(-2147483648 == ft_atoi_base("	+++++--2147483648", "0123456789"));
	assert(0 == ft_atoi_base("	+++++--2147483649", "0123456789"));  // underflow
}

static void test_ft_list_push_front() {
  printf("\n\n\n\n========== ft_list_push_front ==========\n");

  t_list *lst;
  lst = NULL;
  ft_list_push_front(&lst, strdup("element3"));
  ft_list_push_front(&lst, strdup("element2"));
  ft_list_push_front(&lst, strdup("element1"));

  assert(strcmp(lst->data, "element1") == 0);
  assert(strcmp(lst->next->data, "element2") == 0);
  assert(strcmp(lst->next->next->data, "element3") == 0);
  assert(lst->next->next->next == NULL);

  // cleanup
  t_list *current, *prev;
  prev = NULL;
  current = lst;
  while (current != NULL) {
    free(current->data);
    prev = current;
    current = current->next;
    free(prev);
  }
}

static void cleanup_lst(t_list *lst, void (*remove)()) {
  // cleanup
  t_list *current, *prev;
  prev = NULL;
  current = lst;
  while (current != NULL) {
    remove(current->data);
    prev = current;
    current = current->next;
    free(prev);
  }
}

static void test_ft_list_size(){
  printf("\n\n\n\n========== ft_list_size ==========\n");

  t_list *lst;
  lst = NULL;

  assert(ft_list_size(lst) == 0);
  ft_list_push_front(&lst, strdup("element3"));
  assert(ft_list_size(lst) == 1);
  ft_list_push_front(&lst, strdup("element2"));
  assert(ft_list_size(lst) == 2);
  ft_list_push_front(&lst, strdup("element1"));
  assert(ft_list_size(lst) == 3);

  cleanup_lst(lst, free);
}

// current と next を入れ替える
void ft_list_swap(t_list *prev, t_list *current, t_list *next) {
  if (prev) {
    prev->next = next;
  }
  if (next) {
    current->next = next->next;
  } else { current->next = NULL;
  }
  next->next = current;
}

void ft_list_sort(t_list **begin_list, int (*cmp)()) {
  if (begin_list == NULL) {
    return;
  }
  if (*begin_list == NULL) {
    return;
  }
  if (cmp == NULL) {
    return;
  }
  int lst_len = ft_list_size(*begin_list);

  int i = 1;
  t_list *head = *begin_list;
  while (i < lst_len) {
    t_list *prev;
    t_list *current;
    prev = NULL;
    current = head;
    
    while (current->next) {
      if (cmp(current->data, current->next->data) > 0) {
        if (current == head) {
          head = current->next;
        }
        t_list *tmp = current->next;
        ft_list_swap(prev, current, current->next);
        prev = tmp;
      }else{
        prev = current;
        current = current->next;
      }
    }
    i++;
  }
  *begin_list = head;
}

static void test_ft_list_sort(){
  printf("\n\n\n\n========== ft_list_sort ==========\n");

 {
    t_list *lst;
    lst = NULL;

    ft_list_push_front(&lst, strdup("a"));
    ft_list_push_front(&lst, strdup("f"));
    ft_list_push_front(&lst, strdup("c"));
    ft_list_push_front(&lst, strdup("g"));
    ft_list_push_front(&lst, strdup("b"));
    ft_list_push_front(&lst, strdup("e"));
    ft_list_push_front(&lst, strdup("d"));

    ft_list_sort(&lst, strcmp);

    t_list *current = lst;
    char c = 'a';
    while(current) {
      printf("%c: %s\n", c, current->data);

      char buf[10];
      sprintf(buf, "%c", c);
      assert(strcmp(current->data, buf) == 0);
      current = current->next;

      c++;
    }

    cleanup_lst(lst, free);
 }

 {
    t_list *lst;
    lst = NULL;

    ft_list_push_front(&lst, strdup("f"));
    ft_list_push_front(&lst, strdup("a"));

    ft_list_sort(&lst, strcmp);

    assert(strcmp(lst->data, "a") == 0);
    assert(strcmp(lst->next->data, "f") == 0);
    assert(lst->next->next == NULL);

    cleanup_lst(lst, free);
 }

 {
  ft_list_sort(NULL, NULL);
 }
}

static void test_ft_list_remove_if(){
  printf("\n\n\n\n========== ft_list_remove_if ==========\n");
}

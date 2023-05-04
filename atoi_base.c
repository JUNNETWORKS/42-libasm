#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>
#include <limits.h>

int ft_atoi_base(char *str, char *base);

static int ft_strchr(char *s, char c) {
  int i = 0;
  while (s[i]) {
    if (s[i] == c) {
      return i;
    }
    i++;
  }
  return -1;
}

static bool is_valid_base(char *base) {
  if (base == NULL) {
    return false;
  }
  int base_len = strlen(base);
  if (base_len <= 1) {
    return 0;
  }
  // baseに同じ文字が2つ含まれている
  // baseに'+', '-', ' 'が含まれている
  int i = 0;
  while (base[i]) {
    if (ft_strchr(base + i + 1, base[i]) != -1) {
      return false;
    }
    if (base[i] <= 32 || base[i] == '+' || base[i] == '-' || base[i] == 127) {
      return false;
    }
    i++;
  }
  return true;
}

static char *skip_spaces(char *str) {
  while (*str) {
    if (*str > 32 && *str != 127) break;
    str++;
  }
  return str;
}

static char *parse_sign(char *str, int *sign){
  *sign = 1;
  while (*str) {
    // if (*str != '+' && *str != '-') {
    //   break;
    // }
    if (*str < '+') break;
    if (*str > '-') break;
    if (*str == ',') break;
    if (*str == '-') {
      *sign = -1;
    }
    str++;
  }
  return str;
}

int ft_atoi_base(char *str, char *base) {
  int sign;
  int base_len;
  int num;
  int idx;
  // validate
  if (str == NULL || !is_valid_base(base)) {
    return 0;
  }
  // skip spaces
  str = skip_spaces(str);
  // parse sign
  str = parse_sign(str, &sign);
  // parse number
  base_len = strlen(base);
  num = 0;
  while (*str) {
    idx = ft_strchr(base, *str);
    if (idx == -1) break;
    if (sign > 0) {
      if (num > (INT_MAX - idx) / base_len) {
        return 0;
      }
    }
    if (sign < 0){
      if (-1 * num < (INT_MIN + idx) / base_len) {
        return 0;
      }
    }
    num = num * base_len + idx;
    str++;
  }
  return sign * num;
}

int		main(void)
{
	printf("%d\n", ft_atoi_base("	+++++--133742", "0123456789"));
	printf("%d\n", ft_atoi_base("	++++133742", "0123456789"));
	printf("%d\n", ft_atoi_base("	133742", "0123456789"));
	printf("%d\n", ft_atoi_base("	     ---101010", "01"));
	printf("%d\n", ft_atoi_base("	     101010", "01"));
	printf("%d\n", ft_atoi_base(" 	+---539", "0123456789abcdef"));
	printf("%d\n", ft_atoi_base(" 	+539", "0123456789abcdef"));
	printf("%d\n", ft_atoi_base(" 	539", "0123456789abcdef"));
	printf("%d\n", ft_atoi_base("     ", "0123456789abcdef"));

  // overflow and undeflow tests
  printf("----- overflow and undeflow tests -----\n");
	printf("%d\n", ft_atoi_base("	+++++2147483647", "0123456789"));
	printf("%d\n", ft_atoi_base("	+++++2147483648", "0123456789"));  // overflow
	printf("%d\n", ft_atoi_base("	+++++--2147483648", "0123456789"));
	printf("%d\n", ft_atoi_base("	+++++--2147483649", "0123456789"));  // underflow
}
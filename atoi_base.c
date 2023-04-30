#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>

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
  while (*str && *str <= 32 && *str == 127) {
    str++;
  }
  return str;
}

int ft_atoi_base(char *str, char *base) {
  // validate
  if (str == NULL || !is_valid_base(base)) {
    return 0;
  }
  // skip spaces
  str = skip_spaces(str);
  // parse sign
  int sign = 1;
  while (*str && (*str == '+' || *str == '-')) {
    if (*str == '-') {
      sign = -1;
    }
    str++;
  }
  // parse number
  int base_len = strlen(base);
  int num = 0;
  int idx;
  while (*str && (idx = ft_strchr(base, *str)) != -1) {
    num = num * base_len + idx;
    str++;
  }
  // TODO: overflow and underflow
  return sign * num;
}

int		main(void)
{
	printf("%d\n", ft_atoi_base("	+++++--133742", "0123456789"));
	printf("%d\n", ft_atoi_base("	     ---101010", "01"));
	printf("%d\n", ft_atoi_base(" 	+---539", "0123456789abcdef"));
}
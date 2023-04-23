#pragma once

#include <stdlib.h>

size_t ft_strlen(const char *s);
char *ft_strcpy(char *dst, const char *src);
int ft_strcmp(const char *s1, const char *s2);

ssize_t ft_write(int fildes, const void *buf, size_t nbyte);

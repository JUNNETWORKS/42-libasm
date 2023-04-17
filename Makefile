NAME=libasm.a

SRCS = $(wildcard *.s)

OBJS_DIR = objs
OBJS = $(SRCS:%.s=$(OBJS_DIR)/%.o)

$(OBJS_DIR)/%.o: %.s
	@mkdir -p $(@D)
	nasm -f macho64 -o $@ $<

.PHONY: all
all: $(NAME)

$(NAME): $(OBJS)
	ar rc $(NAME) $(OBJS)

.PHONY: clean
clean:
	$(RM) $(OBJS)

.PHONY: fclean
fclean: clean
	$(RM) $(NAME)

.PHONY: re
re: fclean all

.PHONY: bonus
bonus:

TEST_EXE = a.out

.PHONY: test
test: $(NAME)
	gcc -arch x86_64 -lSystem -o $(TEST_EXE) main.c $(NAME)
	./$(TEST_EXE)
	$(RM) $(TEST_EXE)
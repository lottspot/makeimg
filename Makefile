
PROG := makeimg
SRCS := \
  deps/bashlib/src/header.sh  \
  src/print.sh                \
  src/deps.sh                 \
  src/inputs.sh               \
  src/actions.sh              \
  src/main.sh

$(PROG): $(SRCS)
	cat $(SRCS) > $(PROG)
	chmod +x $(PROG)

clean:
	rm -f $(PROG)

.PHONY: clean


PROG := makeimg
SRCS := \
  deps/bashlib/src/header.sh  \
  src/print.sh                \
  src/deps.sh                 \
  src/vars.sh                 \
  src/validation.sh           \
  src/actions.sh              \
  src/confine.sh              \
  src/main.sh

$(PROG): $(SRCS)
	cat $(SRCS) > $(PROG)
	chmod +x $(PROG)

clean:
	rm -f $(PROG)

.PHONY: clean

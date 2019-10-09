
PROG := makeimg
SRCS := \
  deps/bashlib/src/header.sh

$(PROG): $(SRCS)
	cat $(SRCS) > $(PROG)
	chmod +x $(PROG)

clean:
	rm -f $(PROG)

.PHONY: clean

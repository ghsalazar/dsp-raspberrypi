SRCDIR = ../src

TARGETS = $(patsubst %.c, %, $(notdir $(wildcard $(SRCDIR)/*.c)))

LDLIBS = -lgpiod

all: $(TARGETS)

%: $(SRCDIR)/%.c
	$(CC) $<	-o $@	$(LDLIBS)

.PHONNY: clean

clean:
	rm -f $(TARGETS)


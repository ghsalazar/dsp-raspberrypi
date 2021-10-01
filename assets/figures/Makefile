SRCDIR = ../../_src

TARGETS = $(patsubst %.gv, %.svg, $(notdir $(wildcard $(SRCDIR)/*.gv)))

all: $(TARGETS)

%.svg: $(SRCDIR)/%.gv
	dot -Tsvg -o $@ $<

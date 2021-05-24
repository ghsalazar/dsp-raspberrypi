SRC_DIR = ../src
TARGETS = $(notdir $(patsubst %.mdw, %.html, $(wildcard $(SRC_DIR)/*.mdw)))

all: $(TARGETS)

%.html: %.md
	pandoc $<	-o $@
	
%.md: $(SRC_DIR)/%.mdw
	../etc/mdweb/src/mdweave $< > $@

.PHONNY: clean distclean

distclean:


clean:
	rm -f $(TARGETS)
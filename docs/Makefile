SRC_DIR = ../_src
#TARGETS = $(notdir $(patsubst %.md, %.html, $(wildcard $(SRC_DIR)/*.md)))
TARGETS = $(notdir $(wildcard $(SRC_DIR)/*.md))


HTMLFLAGS = --highlight-style espresso 

all: $(TARGETS)
	echo $(TARGETS)

%.html: $(SRC_DIR)/%.md
	sh ../etc/mdweb/src/mdweave  $< 	|	pandoc $(HTMLFLAGS) -f markdown	-o $@

%.md:: $(SRC_DIR)/%.md
	sh ../etc/mdweb/src/mdweave  $< 	|	gpp -H	> $@

.PHONNY: clean distclean

distclean:


clean:
	rm -f $(TARGETS)

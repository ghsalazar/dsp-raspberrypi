SRC_DIR = ../src
SRC = $(wildcard $(SRC_DIR)/*.mdw)

jobs := $(foreach i,1 2 3 4 5,$(foreach j,1 2 3,job-$i-$j))


all: $(SRC)
	for src_file in $(SRC); do \
		for file in $$(../etc/mdweb/src/mdtangle -M $$src_file); do \
			../etc/mdweb/src/mdtangle -R $$file $< > $$file; \
		done \
	done

.PHONNY: clean

clean:
	for src_file in $(SRC); do \
		for file in $$(../etc/mdweb/src/mdtangle -M $$src_file); do \
			rm -f $$file; \
		done \
	done

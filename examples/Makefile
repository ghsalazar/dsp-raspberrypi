SRC_DIR = ../src
SRC = $(wildcard $(SRC_DIR)/*.md)

all: $(SRC)
	for src_file in $(SRC); do \
		for file in $$(sh ../etc/mdweb/src/mdtangle -M $$src_file); do \
			sh ../etc/mdweb/src/mdtangle -R $$file $$src_file > $$file; \
		done \
	done

.PHONNY: clean

clean:
	for src_file in $(SRC); do \
		for file in $$(sh ../etc/mdweb/src/mdtangle -M $$src_file); do \
			rm -f $$file; \
		done \
	done

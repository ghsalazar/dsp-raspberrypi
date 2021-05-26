all:
	make -C examples
	make -C docs

.PHONNY: clean

clean:
	make -C bin $@
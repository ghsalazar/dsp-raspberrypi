all:
	make -C examples
	make -C docs

.PHONNY: clean

clean:
	make -C docs clean
	make -C examples clean
	
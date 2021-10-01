all:
	make -C examples
	make -C docs
	make -C assets/figures

.PHONNY: clean

clean:
	make -C docs clean
	make -C examples clean
	
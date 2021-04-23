all:
	make -C bin

.PHONNY: clean

clean:
	make -C bin $@
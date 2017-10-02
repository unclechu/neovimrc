all: clean clean-old-vundle-stuff
	./make.pl create-symlink

clean:
	./make.pl clean

clean-old-vundle-stuff:
	./make.pl clean-old-vundle-stuff

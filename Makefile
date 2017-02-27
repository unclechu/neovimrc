all: clean
	(cd ~/.config/ && ln -s "$(shell pwd)/" nvim)

clean:
	[ -L ~/.config/nvim -o ! -e ~/.config/nvim ] && rm -f ~/.config/nvim

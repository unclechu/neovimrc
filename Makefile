all: clean
	(cd ~/.config/ && ln -s "$(PWD)/" nvim)

clean:
	[ -L ~/.config/nvim -o ! -e ~/.config/nvim ] && rm -f ~/.config/nvim

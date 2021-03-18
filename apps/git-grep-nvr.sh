#!/usr/bin/env bash
#
# Helps to open a file on specific line via neovim-remove
# by selected match from `git grep` output
# (it will replace current `:terminal` buffer with selected file).
#
# "whiptail" app is required for this script.
# Make sure "whiptail" and this script are both in your `$PATH`.
#
# Use it like this:
#   git grep -nIF -- foo | git-grep-nvr.sh
#
# `-n` and `-I` are required for `git grep` command.
#
# Author: Viacheslav Lotsmanov
#

set -e || exit
options=()

# reading git-grep output from stdin
while read -r match; do
	file=${match%%:*}
	contents=${match#*:}
	line=${contents%%:*}
	contents=${contents#*:} # slicing line number
	if ! [[ $line =~ ^[0-9]+$ ]]; then
		echo \
			'Line number is incorrect, you probably forgot to add ' \
			'`-n` and/or `-I` to `git grep` command.' >&2
		printf $"Line that failed to parse: \"%s\"\n" "$match" >&2
		exit 1
	fi
	options+=("$line:$file" "$contents")
done

CMD=(whiptail --menu 'Select git-grep match:' 0 0 0)
SELECTED=$("${CMD[@]}" -- "${options[@]}" 2>&1 >/dev/tty)
nvr --nostart -c "bd!#" -- "+${SELECTED%%:*}" "${SELECTED#*:}"

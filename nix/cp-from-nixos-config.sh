#! /usr/bin/env bash
# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE
set -o errexit || exit; set -o errtrace; set -o nounset; set -o pipefail

# Copy-paste a file from my NixOS config to this repo.
#
# Just to copy some common helpers.

# Guard dependencies
>/dev/null type git

show-usage() {
	set -o errexit || exit; set -o errtrace; set -o nounset; set -o pipefail
	echo 'Usage examples:'
	echo '  nix/cp-from-nixos-config.sh /etc/nixos/utils/executable-dependencies.nix nix/utils/'
	echo '  nix/cp-from-nixos-config.sh /etc/nixos/utils/mk-generic-script.nix nix/utils/'
}

if (( $# != 2 )); then
	>&2 echo 'Incorrect arguments!'
	>&2 show-usage
	exit 1
fi

FULL_FROM_PATH=$1
FROM_FILE_NAME=${FULL_FROM_PATH##*/}
FROM_POST=${FULL_FROM_PATH#/*/*/}
FROM_PRE=${FULL_FROM_PATH%"$FROM_POST"}

COPY_TO_PATH=$2

if [[ ! -f "$FULL_FROM_PATH" ]]; then
	>&2 printf '[ERR] File “%s” does not exist\n' "$FULL_FROM_PATH"
	exit 1
elif [[ "$FROM_PRE" != /etc/nixos/ ]]; then
	>&2 printf '[ERR] File “%s” must be placed in /etc/nixos/\n' "$FULL_FROM_PATH"
	exit 1
fi

FROM_FILE_LAST_MODIFICATION_COMMIT=$(
	cd -- "$FROM_PRE"
	git log -1 --format=%H -- "$FROM_POST"
)

FROM_FILE_CONTENTS=$(<"$FULL_FROM_PATH")
NEW_CONTENTS=$(
	echo '# DO NOT MODIFY!'
	echo '# This file is an automatic copy from:'
	printf \
		'# https://github.com/unclechu/nixos-config/blob/%s/%s\n' \
		"$FROM_FILE_LAST_MODIFICATION_COMMIT" \
		"$FROM_POST"
	echo '# The file copied using “cp-from-nixos-config.sh” script.'
	echo
	echo '# ——————————————————————————————————————————————————————————————————————————————'
	echo
	printf '%s\n' "$FROM_FILE_CONTENTS"
)

if [[ -d "$COPY_TO_PATH" ]]; then
	COPY_TO=$COPY_TO_PATH/$FROM_FILE_NAME
else
	COPY_TO=$COPY_TO_PATH
fi

printf '%s\n' "$NEW_CONTENTS" > "$COPY_TO"

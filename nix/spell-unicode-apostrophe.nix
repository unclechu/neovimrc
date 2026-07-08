# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

{ runCommand
, neovim
}:

# Generated extra spell file for English language that adds unicode apostrophe
# (“’”) variants for all words containing ASCII apostrophe (“'”).
#
# Usage example (in your generated `init.vim`, Nix string substitution):
#
#   let &rtp .= ',${callPackage ./spell-unicode-apostrophe.nix {}}'
#
runCommand "nvim-spell-unicode-apostrophe" {
  nativeBuildInputs = [ neovim ];
} ''(
  set -o errexit || exit; set -o errtrace; set -o nounset; set -o pipefail

  DUMP_FILE=dump.txt
  UNICODE_WORDS_FILE="$out/spell/en.utf-8.add"
  COMPILED_UNICODE_SPELL_FILE="$out/spell/en.utf-8.add.spl"

  (
    export NVIM_LOG_FILE=/dev/null
    export FILE="$DUMP_FILE"
    NVIM_DUMP_SPELL_CMD=(
      nvim -n --clean --headless
      -c 'set encoding=utf-8'
      -c 'set spell spelllang=en_us'
      -c 'spelldump'
      -c 'silent write! $FILE'
      -c 'qa!'
    )
    "''${NVIM_DUMP_SPELL_CMD[@]}"
    [[ -f "$DUMP_FILE" ]] # Spell dump file must be created
  )

  mkdir -p -- "$out/spell"

  # Take the spell dump file and filter only words containing ASCII apostrophe
  # and replace those apostrophe with unicode ones.
  {
    printf '/encoding=utf-8\n'
    awk '
      BEGIN { apos = sprintf("%c", 39) }

      /^[[:space:]]*$/ { next }
      /^#/ { next }
      /^\// { next }

      {
        word = $0

        # Drop whitespace/comment tail.
        sub(/[[:space:]].*$/, "", word)

        # Drop spell metadata like /2, /24, /245.
        sub(/\/[^/]*$/, "", word)

        if (index(word, apos) > 0) {
          gsub(apos, "’", word)
          print word
        }
      }
    ' "$DUMP_FILE" | sort -u
  } > "$UNICODE_WORDS_FILE"

  # Generate binary spell file out of the words list
  (
    export NVIM_LOG_FILE=/dev/null
    export FILE="$UNICODE_WORDS_FILE"
    nvim -n --clean --headless -c 'mkspell! $FILE' -c 'qa!'
    [[ -f "$COMPILED_UNICODE_SPELL_FILE" ]] # Must be generated
  )
)''

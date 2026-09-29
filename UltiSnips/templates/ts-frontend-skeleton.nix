{ pkgs ? import <nixpkgs> {}

, lib ? pkgs.lib
, nodejs ? pkgs.nodejs
, pnpm-unwrapped ? pkgs.pnpm
, jq ? pkgs.jq

, inNixShell ? false # Automatically set to true by nix-shell call
}:

let
  shExe = pkg: lib.escapeShellArg (lib.getExe pkg);
  shExe' = pkg: executable: lib.escapeShellArg (lib.getExe' pkg executable);

  shell = pkgs.mkShell {
    packages = [
      # generate-skeleton {{{
      # TODO: Remove after project skeleton is created (will be removed automatically)
      (pkgs.writeShellScriptBin "generate-skeleton" ''
        set -o errexit || exit; set -o errtrace; set -o nounset; set -o pipefail
        set -o xtrace

        # Initialize the Vite project first
        (
          # Vite requires current directory to be empty (but there’s default.nix)
          DIR=$(${shExe' pkgs.coreutils "mktemp"} -d)
          pushd -- "$DIR"
          ${shExe pnpm} create vite . --template react-ts --no-interactive
          popd
          mv -v -- "$DIR"/* .
        )
        ${shExe pnpm} install
        # Update from TypeScript 6 to 7.
        # Vite template uses 6 by default which does not have builtin LSP support.
        ${shExe pnpm} add -D typescript@^7
        # Add dependencies for testing
        ${shExe pnpm} add -D vitest jsdom '@testing-library/react' '@testing-library/jest-dom'
        # Add Oxlint and Oxfmt
        ${shExe pnpm} add -D oxlint oxlint-tsgolint oxfmt

        # Patch package.json
        package_json=$(<package.json ${shExe jq} '.
          | .license = "--TBD--"
          | .author = "Wenzel"
          | .scripts |= (. + {
            "typecheck": "tsc -b",
            "lint": "oxlint --type-aware",
            "lint:fix": "oxlint --type-aware --fix",
            "format": "oxfmt --write .",
            "format:check": "oxfmt --check .",
            "test": "vitest run",
            "test:watch": "vitest",
          })
        ')
        printf '%s\n' "$package_json" > package.json

        # Create some tests
        mkdir -p test
        >test/App.test.tsx printf %s ${lib.escapeShellArg ''
          // @vitest-environment jsdom
          import '@testing-library/jest-dom/vitest';
          import { render, screen } from '@testing-library/react';
          import { expect, test } from 'vitest';

          import App from '../src/App';

          test('Renders “Get started”', () => {
            render(<App />)

            expect(
              screen.getByRole('heading', {
                name: 'Get started',
              }),
            ).toBeInTheDocument()
          });
        ''}

        # Create Oxfmt configuration
        >.oxfmtrc.json printf %s ${lib.escapeShellArg ''
          {
            "$schema": "./node_modules/oxfmt/configuration_schema.json",
            "printWidth": 100,
            "tabWidth": 2,
            "useTabs": false,
            "semi": true,
            "singleQuote": true,
            "trailingComma": "all",
            "categories": {
              "correctness": "error",
              "suspicious": "warn",
              "style": "warn"
            }
          }
        ''}

        # Create direnv configuration example file
        >.envrc.example printf %s ${lib.escapeShellArg ''
          use nix
        ''}

        # Make a symlink to the direnv example file (will not be committed)
        ${shExe' pkgs.coreutils "ln"} -s .envrc.example .envrc

        # Create .editorconfig
        >.editorconfig printf %s ${lib.escapeShellArg ''
          root = true

          [*]
          indent_style = space
          indent_size = 2
          charset = utf-8
          trim_trailing_whitespace = true
          insert_final_newline = true
          end_of_line = lf
          max_line_length = 100
        ''}

        # Create generic .gitignore configuration
        >.gitignore printf %s ${lib.escapeShellArg ''
          # Dependencies
          node_modules/

          # Build output
          dist/
          build/
          out/
          coverage/

          # TypeScript incremental build info
          *.tsbuildinfo

          # Environment / secrets
          .env
          .env.*
          !.env.example

          # direnv configuration
          .envrc
          .envrc.*
          !.envrc.example

          # Logs
          *.log
          npm-debug.log*
          pnpm-debug.log*
          yarn-debug.log*
          yarn-error.log*

          # Archives / packaged artifacts
          *.zip
          *.tar
          *.tar.gz
          *.tgz
          *.tar.bz2
          *.tbz2
          *.tar.xz
          *.txz
          *.gz
          *.bz2
          *.xz
          *.7z
          *.rar

          # Package artifacts
          *.deb
          *.rpm
          *.apk
          *.pkg

          # Temporary files
          *.tmp
          *.temp
          *.bak
          *.old
          *.orig

          # Editor files
          .idea/
          .vscode/
          *.swp
          *.swo
          *~

          # OS metadata
          .DS_Store
          Thumbs.db

          # Test / tooling caches
          .nyc_output/
          .cache/
          .eslintcache

          # Misc generated files
          *.pid
          *.pid.lock

          # Nix default build artifacts
          result
          result-*
        ''}

        # Smoke test
        ${shExe pnpm} run format
        ${shExe pnpm} run lint
        ${shExe pnpm} run typecheck
        ${shExe pnpm} run test

        # Removing this skeleton generator from this Nix configuration file
        (
          OPENING='^[[:space:]]*# generate-skeleton {{{[[:space:]]*$'
          CLOSING='^[[:space:]]*# generate-skeleton }}}[[:space:]]*$'
          ${shExe pkgs.gnused} -i "/$OPENING/,/$CLOSING/d" default.nix
        )

        # Add local Vim configuration for my own setup (will not be committed)
        >.lvimrc printf %s ${lib.escapeShellArg ''
          set cc=81,101 tw=100

          nn <leader>fa :up<cr>:!pnpm format %<cr>

          if executable('pnpm')
            call systemlist(['pnpm', 'exec', 'tsc', '--version'])
            if v:shell_error == 0
              lua
                \ vim.g.SetupNeovimLsp({
                \   ts_ls = {
                \     cmd = {
                \       'pnpm', 'exec', 'tsc', '--lsp', '--stdio'
                \     }
                \   }
                \ })
              " For builtin TypeScript >=7 LSP server
              " 'pnpm', 'exec', 'tsc', '--lsp', '--stdio'
              " 'npx', 'tsc', '--lsp', '--stdio'
              " For TypeScript older than 7
              " 'npx', 'typescript-language-server', '--stdio'
              " 'pnpm', 'exec', 'typescript-language-server', '--stdio'
            endif
          endif
        ''}

        # Create a Git repo and make an initial skeleton commit
        ${shExe pkgs.git} init
        echo '.lvimrc' >> .git/info/exclude
        ${shExe pkgs.git} add .
        ${shExe pkgs.git} commit -em 'Initialize project skeleton'
      '')
      # generate-skeleton }}}
      nodejs
      pnpm
      jq
    ];

    # Make Vite/Rolldown binaries to find the linked dependencies
    LD_LIBRARY_PATH = lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
      pkgs.glibc
    ];
  };

  # pnpm Nix wrapper.
  pnpm = pkgs.writeShellScriptBin "pnpm" ''
    set -o errexit || exit; set -o errtrace; set -o nounset; set -o pipefail

    # pnpm tries to pull random linked binaries dynamically from the internet
    # and run them. It won’t work on NixOS. Enforce pnpm executable built by
    # Nix.
    export pnpm_config_pm_on_fail=ignore

    exec ${shExe pnpm-unwrapped} "$@"
  '';
in

(if inNixShell then shell else {}) // {
  inherit shell pnpm;
}

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

        # Initialize the project with pnpm first
        ${shExe pnpm} init
        ${shExe pnpm} add -D typescript tsx @types/node oxlint oxlint-tsgolint oxfmt
        ${shExe pnpm} add hono @hono/node-server
        ${shExe pnpm} exec tsc --init

        # Patch package.json
        package_json=$(<package.json ${shExe jq} '.
          | .license = "--TBD--"
          | .author = "Wenzel"
          | .main = "src/index.ts"
          | .scripts = {
            "dev": "tsx watch src/index.ts",
            "start": "tsx src/index.ts",
            "typecheck": "tsc --noEmit",
            "lint": "oxlint --type-aware",
            "lint:fix": "oxlint --type-aware --fix",
            "format": "oxfmt --write .",
            "format:check": "oxfmt --check .",
            "test": "tsx --test",
            "test:watch": "tsx --test --watch",
            "dev-server": "tsx watch src/server.ts",
            "start-server": "tsx src/server.ts"
          }
        ')
        printf '%s\n' "$package_json" > package.json

        # Create directories
        mkdir -p src test

        # Create sources files
        >src/index.ts printf %s ${lib.escapeShellArg ''
          export function hello(name: string): string {
            return `Hello, ''${name}!`;
          }

          if (import.meta.main) {
            console.log(hello('world'));
          }
        ''}
        >test/index.test.ts printf %s ${lib.escapeShellArg ''
          import assert from 'node:assert/strict';
          import test from 'node:test';

          import { hello } from '../src/index.ts';

          test('hello', () => {
            assert.equal(hello('world'), 'Hello, world!');
          });
        ''}
        >src/server.ts printf %s ${lib.escapeShellArg ''
          import { serve } from '@hono/node-server';
          import { Hono } from 'hono';

          export const app = new Hono();

          app.get('/', (c) =>
            c.json({
              message: 'Hello, world!',
            }),
          );

          type Coordinates = {
            latitude: number;
            longitude: number;
          };

          // Returns coordinates or null if specified location is not found
          const getCoordinatesByLocation = async (location: string): Promise<Coordinates | null> => {
            const url = new URL('https://geocoding-api.open-meteo.com/v1/search');
            url.searchParams.set('name', location);
            url.searchParams.set('count', String(1));
            url.searchParams.set('language', 'en');
            url.searchParams.set('format', 'json');

            const headers = new Headers();
            headers.append('Accept', 'application/json');

            const { results } = await fetch(url, { headers }).then((x) => x.json());

            if (Array.isArray(results) && results.length > 0)
              return {
                latitude: results[0].latitude,
                longitude: results[0].longitude,
              } satisfies Coordinates;
            else if (results == null || (Array.isArray(results) && results.length == 0)) return null;
            else throw new TypeError('“results” is of unexpected type');
          };

          // Returns temperature value and temperature unit pair
          const getWeatherByCoordinates = async (coords: Coordinates): Promise<[number, string]> => {
            const url = new URL('https://api.open-meteo.com/v1/forecast');
            url.searchParams.set('latitude', String(coords.latitude));
            url.searchParams.set('longitude', String(coords.longitude));
            url.searchParams.set('current', 'temperature');

            const headers = new Headers();
            headers.append('Accept', 'application/json');

            const { current, current_units } = await fetch(url, { headers }).then((x) => x.json());

            const temp = current?.temperature;
            const temp_unit = current_units?.temperature;

            if (
              temp == null ||
              temp_unit == null ||
              typeof temp !== 'number' ||
              typeof temp_unit !== 'string'
            )
              throw new TypeError('Unexpected response from open-meteo forecast endpoint');

            return [temp, temp_unit];
          };

          type WeatherResponse = {
            temperature: number;
            unit: string;
          };

          app.get('/weather/:location', async (c) => {
            const location: string = c.req.param('location');

            const coords: null | Coordinates = await getCoordinatesByLocation(location);
            if (coords === null) return c.json({ error: `Location “''${location}” not found` }, 404);

            const weather = await getWeatherByCoordinates(coords);

            return c.json({
              temperature: weather[0],
              unit: weather[1],
            } satisfies WeatherResponse);
          });

          if (import.meta.main) {
            const port: number = 3000;
            console.error(`Listening to port ''${port}…`);
            serve({ fetch: app.fetch, port });
          }
        ''}
        >test/server.test.ts printf %s ${lib.escapeShellArg ''
          import assert from 'node:assert/strict';
          import test from 'node:test';

          import { app } from '../src/server.ts';

          test('GET / returns hello world', async () => {
            const response = await app.request('/');

            assert.equal(response.status, 200);

            assert.deepEqual(await response.json(), {
              message: 'Hello, world!',
            });
          });
        ''}

        # Create TypeScript configuration
        >tsconfig.json printf %s ${lib.escapeShellArg ''
          {
            "compilerOptions": {
              "target": "ESNext",
              "module": "NodeNext",
              "moduleResolution": "NodeNext",
              "types": ["node"],
              "noEmit": true,
              "rewriteRelativeImportExtensions": true,
              "erasableSyntaxOnly": true,
              "verbatimModuleSyntax": true,
              "strict": true
            },
            "include": [
              "src/**/*.ts",
              "test/**/*.ts"
            ]
          }
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

        # Smoke test
        ${shExe pnpm} run format
        ${shExe pnpm} run lint
        ${shExe pnpm} run typecheck
        ${shExe pnpm} run test
        ${shExe pnpm} run start

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
  };

  # pnpm Nix wrapper.
  pnpm = pkgs.writeShellScriptBin "pnpm" ''
    set -o errexit || exit; set -o errtrace; set -o nounset; set -o pipefail

    # pnpm tries to pull random linked binaries dynamically from the internet
    # and run them. It won’t work on NixOS. Enforce pnpm executable built by
    # Nix.
    export pnpm_config_pm_on_fail=ignore

    # Ignore post-install scripts which are also basically pulling arbitrary
    # binary executables from the internet.
    export pnpm_config_ignore_scripts=true

    exec ${shExe pnpm-unwrapped} "$@"
  '';
in

(if inNixShell then shell else {}) // {
  inherit shell pnpm;
}

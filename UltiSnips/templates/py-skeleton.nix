{ pkgs ? import <nixpkgs> {}

, lib ? pkgs.lib
, jq ? pkgs.jq
, yq ? pkgs.yq

, gnumake ? pkgs.gnumake
, python3 ? pkgs.python3
, uv-unwrapped ? pkgs.uv # Python package manager
, ruff ? pkgs.ruff # Python linter
, ty ? pkgs.ty # Python type-checker & LSP server

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

        # Initialize the project first using uv
        ${shExe uv} init --bare
        ${shExe uv} add 'fastapi[standard-no-fastapi-cloud-cli]' httpx
        ${shExe uv} add --dev pytest ruff ty

        >Makefile printf %s ${lib.pipe ''
          .PHONY: dev test lint format format-check typecheck check

          dev:
            uv run fastapi dev app/main.py

          test:
            uv run python -m pytest

          lint:
            uv run ruff check .

          format:
            uv run ruff check --fix .
            uv run ruff format .

          format-check:
            uv run ruff check .
            uv run ruff format --check .

          typecheck:
            uv run ty check

          check: format-check typecheck test
        '' [
          (lib.replaceStrings ["\n  "] ["\n\t"])
          lib.escapeShellArg
        ]}

        # Create some tests
        mkdir -p app tests
        >app/main.py printf %s ${lib.escapeShellArg ''
          import httpx
          from fastapi import FastAPI, HTTPException

          app = FastAPI()


          @app.get('/')
          def root() -> dict[str, str]:
              return {
                  'message': 'Hello, world!',
              }


          # Returns latitude and longitude pair or None is specified location is not found
          async def get_coordinates_by_location(location: str) -> tuple[float, float] | None:
              async with httpx.AsyncClient() as client:
                  response = await client.get(
                      'https://geocoding-api.open-meteo.com/v1/search',
                      params={
                          'name': location,
                          'count': 1,
                          'language': 'en',
                          'format': 'json',
                      },
                  )
                  response.raise_for_status()

              data = response.json()
              results = data.get('results')

              if isinstance(results, list) and len(results):
                  result = results[0]
                  return result['latitude'], result['longitude']
              elif results is None or (isinstance(results, list) and len(results) == 0):
                  return None
              else:
                  raise TypeError("'results' is of unexpected type")


          def is_number(value) -> bool:
              return isinstance(value, (int, float)) and not isinstance(value, bool)


          # Returns temperature value and temperature unit pair
          async def get_weather_by_coordinates(coords: tuple[float, float]) -> tuple[float, str]:
              async with httpx.AsyncClient() as client:
                  response = await client.get(
                      'https://api.open-meteo.com/v1/forecast',
                      params={
                          'latitude': coords[0],
                          'longitude': coords[1],
                          'current': 'temperature',
                      },
                  )
                  response.raise_for_status()

              data = response.json()

              temp = (data.get('current') or {}).get('temperature')
              temp_unit = (data.get('current_units') or {}).get('temperature')

              if temp is None or temp_unit is None or not is_number(temp) or not isinstance(temp_unit, str):
                  raise TypeError('Unexpected response from open-meteo forecast endpoint')

              return float(temp), temp_unit


          @app.get('/weather/{location}')
          async def weather(location: str) -> dict[str, str | int | float]:
              coords = await get_coordinates_by_location(location)
              if coords is None:
                  raise HTTPException(status_code=404, detail=f'Location “{location}” not found')
              weather = await get_weather_by_coordinates(coords)
              return {'temperature': weather[0], 'unit': weather[1]}
        ''}
        >tests/test_main.py printf %s ${lib.escapeShellArg ''
          from fastapi.testclient import TestClient

          from app.main import app


          client = TestClient(app)


          def test_root() -> None:
              response = client.get('/')

              assert response.status_code == 200
              assert response.json() == {
                  'message': 'Hello, world!',
              }
        ''}

        # Create direnv configuration example file
        >.envrc.example printf %s ${lib.escapeShellArg ''
          use nix
        ''}

        # Make a symlink to the direnv example file (will not be committed)
        ${shExe' pkgs.coreutils "ln"} -s .envrc.example .envrc

        # Append some code styling configurations for the Ruff and pytest root dir
        >>pyproject.toml printf '\n%s' ${lib.escapeShellArg ''
          [tool.ruff]
          line-length = 100

          [tool.ruff.format]
          quote-style = "single"
          indent-style = "space"

          [tool.ruff.lint]
          extend-select = ["N"]

          [tool.pytest.ini_options]
          pythonpath = ["."]
        ''}

        # Create .editorconfig
        >.editorconfig printf %s ${lib.escapeShellArg ''
          root = true

          [*]
          charset = utf-8
          end_of_line = lf
          insert_final_newline = true
          trim_trailing_whitespace = true

          [*.py]
          indent_style = space
          indent_size = 4
          max_line_length = 100

          [*.{toml,yml,yaml,json}]
          indent_style = space
          indent_size = 2

          [*.md]
          trim_trailing_whitespace = false

          [Makefile]
          indent_style = tab
        ''}

        # Create generic .gitignore configuration
        >.gitignore printf %s ${lib.escapeShellArg ''
          # direnv configuration
          .envrc
          .envrc.*
          !.envrc.example

          # Virtual environments
          .venv/
          venv/
          env/

          # Python bytecode / caches
          __pycache__/
          *.py[cod]
          *$py.class

          # Packaging / build output
          build/
          dist/
          *.egg-info/
          .eggs/
          wheels/
          wheelhouse/

          # Test / coverage output
          .pytest_cache/
          .coverage
          .coverage.*
          coverage.xml
          htmlcov/

          # Tool caches
          .ruff_cache/
          .mypy_cache/
          .pyright/
          .ty/

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

          # Native / package artifacts
          *.so
          *.dylib
          *.dll
          *.deb
          *.rpm
          *.apk
          *.pkg

          # Jupyter
          .ipynb_checkpoints/

          # SQLite / local databases
          *.sqlite
          *.sqlite3
          *.db

          # Misc generated files
          *.pid
          *.pid.lock

          # Nix default build artifacts
          result
          result-*
        ''}

        # Smoke test
        ${shExe ruff} check .
        ${shExe ruff} format --check .
        ${shExe ty} check
        ${shExe uv} run pytest

        # Removing this skeleton generator from this Nix configuration file
        (
          OPENING='^[[:space:]]*# generate-skeleton {{{[[:space:]]*$'
          CLOSING='^[[:space:]]*# generate-skeleton }}}[[:space:]]*$'
          ${shExe pkgs.gnused} -i "/$OPENING/,/$CLOSING/d" default.nix
        )

        # Add local Vim configuration for my own setup (will not be committed)
        >.lvimrc printf %s ${lib.escapeShellArg ''
          set cc=81,101 tw=100
          if executable('ty')
            lua vim.g.SetupNeovimLsp({
              \ ty = { cmd = { 'ty', 'server' } },
              \ ruff = { cmd = { 'ruff', 'server' } },
              \ })
          endif
        ''}

        # Create a Git repo and make an initial skeleton commit
        ${shExe pkgs.git} init
        echo '.lvimrc' >> .git/info/exclude
        ${shExe pkgs.git} add .
        ${shExe pkgs.git} commit -em 'Initialize project skeleton'
      '')
      # generate-skeleton }}}
      jq
      yq
      gnumake
      python3
      uv
      ruff
      ty
    ];
  };

  # uv Nix wrapper.
  uv = pkgs.writeShellScriptBin "uv" ''
    set -o errexit || exit; set -o errtrace; set -o nounset; set -o pipefail

    # Nix owns Python. Never let uv download another interpreter.
    export UV_PYTHON_DOWNLOADS=never
    export UV_PYTHON_PREFERENCE=only-system

    SYNC_ARGS=(
      --no-install-package ruff
      --no-install-package ty
    )

    case "''${1-}:''${2-}" in
      sync:*)
        shift
        exec ${shExe uv-unwrapped} sync "''${SYNC_ARGS[@]}" "$@"
        ;;

      run:ruff)
        shift 2
        exec ${shExe ruff} "$@"
        ;;

      run:ty)
        shift 2
        exec ${shExe ty} "$@"
        ;;

      *)
        exec ${shExe uv-unwrapped} "$@"
        ;;
    esac

    exec ${shExe uv-unwrapped} "''${ARGS[@]}" "$@"
  '';
in

(if inNixShell then shell else {}) // {
  inherit shell uv;
}

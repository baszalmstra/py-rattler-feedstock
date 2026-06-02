@echo on

set CARGO_PROFILE_RELEASE_STRIP=symbols
set CARGO_PROFILE_RELEASE_LTO=fat
@rem Remove this wrapper once https://github.com/conda-forge/rust-activation-feedstock/pull/79 is merged
copy %RECIPE_DIR%\cargo-auditable-wrapper.bat %BUILD_PREFIX%\Library\bin\cargo-auditable-wrapper.bat
if %ERRORLEVEL% neq 0 exit 1
set "CARGO=cargo-auditable-wrapper.bat"

set "CMAKE_GENERATOR=NMake Makefiles"

@rem Use native-tls on conda-forge and limit parallelism to keep memory usage down
set "MATURIN_PEP517_ARGS=--no-default-features --features=native-tls --jobs 1"

@rem Run the maturin build via pip which works for both direct and
@rem cross-compiled builds (e.g. win-arm64). Installing a pre-built wheel
@rem directly does not work when cross-compiling because the wheel does not
@rem match the build interpreter's platform.
%PYTHON% -m pip install . -vv || exit 1

cd py-rattler

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml || exit 1

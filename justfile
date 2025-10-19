build:
    typst compile slides.typ

compile-plugin:
    #!/usr/bin/env bash
    cd plugins/tokenize-ja/
    cargo build --release
    cp target/wasm32-unknown-unknown/release/typst_plugin_tokenize_ja.wasm tokenize-ja.wasm

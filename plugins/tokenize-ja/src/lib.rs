use ciborium::ser::into_writer;
use wasm_minimal_protocol::*;

initiate_protocol!();

mod tokenize;

#[wasm_func]
pub fn init() -> Result<Vec<u8>, anyhow::Error> {
    tokenize::init()?;
    Ok(Vec::new())
}

#[wasm_func]
pub fn tokenize(text: &[u8]) -> Result<Vec<u8>, anyhow::Error> {
    let result = tokenize::tokenize(str::from_utf8(text)?)?;
    let mut out = Vec::new();
    into_writer(&result, &mut out)?;
    Ok(out)
}

use anyhow::anyhow;
use anyhow::Context;
use lindera::dictionary::load_dictionary;
use lindera::mode::Mode;
use lindera::segmenter::Segmenter;
use lindera::tokenizer::Tokenizer;
use std::sync::OnceLock;

static TOKENIZER: OnceLock<Tokenizer> = OnceLock::new();

pub fn init() -> Result<(), anyhow::Error> {
    let dictionary = load_dictionary("embedded://ipadic").context("failed to load dictionary")?;
    let segmenter = Segmenter::new(Mode::Normal, dictionary, None);
    let tokenizer = Tokenizer::new(segmenter);
    TOKENIZER
        .set(tokenizer)
        .map_err(|_| anyhow!("failed to initialize tokenizer"))?;
    Ok(())
}

pub fn tokenize(text: &str) -> Result<Vec<(String, Option<String>)>, anyhow::Error> {
    let tokenizer = TOKENIZER.get().context("call load() first")?;
    let mut tokens = tokenizer
        .tokenize(text)
        .context("failed to tokenize text")?;
    Ok(tokens
        .iter_mut()
        .map(|t| {
            let surface: String = t.surface.to_string();
            let detail = t.get_detail(0).map(|s| s.into());
            (surface, detail)
        })
        .collect())
}

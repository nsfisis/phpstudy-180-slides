#import "@preview/touying:0.6.1": *
#import "@preview/cjk-unbreak:0.2.0": remove-cjk-break-space, transform-childs
#import "setoka.typ": *

#show: remove-cjk-break-space

#let plugin_tokenize_ja_uninitialized = plugin("plugins/tokenize-ja/tokenize-ja.wasm")
#let plugin_tokenize_ja = plugin.transition(plugin_tokenize_ja_uninitialized.init)

#let tokenize(s) = {
  cbor(plugin_tokenize_ja.tokenize(bytes(s)))
}

#let make-助詞-small(rest) = {
  rest = transform-childs(rest, make-助詞-small)
  if utils.is-sequence(rest) {
    for child in rest.children {
      if child.func() == text {
        if child.has("text") {
          for t in tokenize(child.text) {
            if t.at(1) == "助詞" {
              [#set text(size: 0.9em);#t.at(0)]
            } else {
              t.at(0)
            }
          }
        } else if child.has("body") {
          for t in tokenize(child.body) {
            if t.at(1) == "助詞" {
              [#set text(size: 0.9em);#t.at(0)]
            } else {
              t.at(0)
            }
          }
        } else {
          child
        }
      } else {
        child
      }
    }
  } else {
    rest
  }
}

#show: make-助詞-small

#show: setoka-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [
      浮動小数点数の半開区間で \
      単一値を指定する
    ],
    subtitle: [PHP 勉強会\@東京 第 180 回],
    author: [nsfisis (いまむら)],
    date: datetime(year: 2025, month: 10, day: 29),
  ),
)

#set text(font: "Noto Sans CJK JP", lang: "ja")

#title-slide()

#about-slide()

数値の範囲を指定して \
検索する API

---

半開区間 \
[x, y) \
x を含み、y を含まない

---

[3, 7) \
3, 4, 5, 6

---

ちょうど 1 点を指定したい！

---

ちょうど 5 \
[5, 6)

---

ちょうど n \
[n, n+1)

---

整数ならこれで OK

---

実数なら？

---

ちょうど 1 \
[1, 2) \
1, 1.5, 1.7, 1.989

---

[1, 1より少しだけ大きい値) \
間に 1 しか入らない範囲

#pause

可能か？

---

[1, p) \
間に 1 しか入らない範囲？

#pause

$(1+p)/2$ が入る

---

実数では無理

#pause

コンピュータ上の実数なら？

---

コンピュータ上の実数表現は \
有限精度

#pause

あらゆる実数を表現できる \
わけ*ではない*

---

[1, p) \
間に 1 しか入らない範囲

#pause

コンピュータ上なら \
都合のいい p が存在する

---

ここからは *IEEE 754* を仮定

#pause

#[
  #set text(size: 0.7em)
  IEEE 754

  浮動小数点数の表現や扱いを定めた \
  標準規格
]

---

[1, p) \
間に 1 しか入らない範囲

#pause

p = 1.0000000000000002

#[
  #set text(size: 0.7em)
  64 bit の二進浮動小数点数の場合
]

---

#[
  #set text(size: 0.7em)
  1 = \
  00111111111100000000000000000000... \
  ...00000000000000000000000000000000
]

#pause

#[
  #set text(size: 0.7em)
  p = \
  00111111111100000000000000000000... \
  ...00000000000000000000000000000001
]

---

[1, p) \
p = 1.0000000000000002

#pause

[x, y) \
y = ?

---

[x, y) \
#[
  #set text(size: 0.8em)
  y =
  64 bit の二進浮動小数点数で \
  表現可能な値のうち、\
  x の*次*に大きい数
]

---

IEEE 754

#pause

- nextUp
- nextDown

---

[x, y) \
間に x しか入らない範囲

#pause

y = nextUp(x)

---

- C言語
  - `nextup()`
  - `nextdown()`
  - `nextafter()`

---

- Java
  - `Math.nextUp()`
  - `Math.nextDown()`
  - `Math.nextAfter()`

---

PHP には \
nextUp も nextDown も \
無い！

---

無いので作りました \
#link("https://packagist.org/packages/nsfisis/next-after")[nsfisis/php-next-after]

---

#[
  #set text(size: 0.7em)

  ```php
  use Nsfisis\NextAfter\NextAfter;

  function toExactFloatRange(
    float $from,
  ): array {
      $to = NextAfter::nextUp($from);
      return [$from, $to];
  }
  ```
]

---

#[
  #set align(center + horizon)

  ご静聴 \
  ありがとうございました
]

#import "@preview/touying:0.6.1": *
#import "setoka.typ": *

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

#set text(font: "Noto Sans CJK JP")

#title-slide()

#about-slide()

数値の範囲を指定して検索する API

---

半開区間
[x, y)
x を含み、y を含まない

---

[3, 7)
3, 4, 5, 6

---

ちょうど 5
[5, 6)

---

ちょうど n
[n, n+1)

---

整数ならこれで OK

---

実数なら？

---

ちょうど 1
[1, 2)
1, 1.5, 1.7, 1.989

---

[1, 1より少しだけ大きい値)
間に 1 しか入らない範囲

---

[1, p)
間に 1 しか入らない範囲？

---

[1, p)
間に 1 しか入らない範囲？
(1+p)/2 が入る

---

無理 (実数では)

---

実数は無限精度ある

---

コンピュータ上の実数表現は
有限精度

---

[1, p)

---

[1, p)
コンピュータ上なら
都合のいい p が存在する

---

64 bit の浮動小数点数の場合
[1, p)
p = 1.0000000000000002

---

1 = 0011111111110000000000000000000000000000000000000000000000000000
p = 0011111111110000000000000000000000000000000000000000000000000001

---

浮動小数点数
IEEE 754

---

IEEE 754
nextUp
nextDown

---

IEEE 754
nextUp: 僅かに大きい値を返す
nextDown: 僅かに小さい値を返す

---

ちょうど x
[x, nextUp(x))

---

PHP には nextUp/nextDown が無い

---

無いので作りました
nsfisis/php-next-after

---

```php
use Nsfisis\NextAfter\NextAfter;

function toExactFloatRange($from) {
    $to = NextAfter::nextUp($from);
    return [$from, $to];
}
```

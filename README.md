#nihonjin 日本人

このgemはまだできてないし、公開してないけど、次のことがしたいです。

３つのクラスを作りたい<br/>
`Suji`<br/>
`Moji`<br/>
`Toshi`<br/>

##Suji 数字
今はSujiが少しだけできてる<br/>
次のメソッドでは、どんな値でも入れていい
```ruby
# 今のところは、kanji_henkanは８桁まで変換できます
p Suji.kanji_henkan(150)
#=> "百五十"
p Suji.kanji_henkan(3521)
#=> "三千五百二十一"
p Suji.kanji_henkan(27825672)
#=> "二千七百八十二万五千六百七十二"


p Suji.zenkaku(300)
#=> "３００"
p Suji.hankaku("三〇〇")
#=> "300"

# kanji_henkanと違って、普通に数字をそのまま漢字に変換する
p Suji.kanji(800)
#=> "八〇〇"
p Suji.daiji("三")
#=> "参"
p Suji.type?(10)
#=> "半角"

# to_iも使えます
# 尚、上にあるkanji_henkan()が返すような値ではto_iは使えません
p Suji.to_i("三〇一")
#=> 301
p Suji.to_i("３０１")
#=> 301
p Suji.to_i("参零壱")
#=> 301
```

10_000の場合は「一万」になってるけど、1_000は「千」だけになってる。<br/>
合ってるかどうか分からないけど、合ってるような気がするww<br/>
誰か教えてくださいww<br/>

<a href="http://www.geocities.jp/f9305710/kazu.html">リンク</a>

## Moji 文字
文字列をひらがな、カタカナ、半角カタカタ、ローマ字のいずれかに変換できます（漢字は使えません）<br/>

```ruby
mojiretsu = "おすし　は　おいしい　です　ね。"
Moji.romaji(mojiretsu)
#=> "osushi wa oishii desu ne."
```

###<a href="https://ja.wikipedia.org/wiki/%E5%A4%A7%E5%AD%97_(%E6%95%B0%E5%AD%97)" target="_blank">このリンク</a>を参考にしてください

## Toshi 年

##しないといけないこと
テストはあんまり綺麗じゃない<br/>
一つの方法を決めて分かりやすくて綺麗にすること

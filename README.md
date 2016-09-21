# 日本人 nihonjin

３つのクラスを作りたい
Suji
Moji
Toshi

今はSujiが少しだけできてる
```ruby
p Suji.zenkaku(300)
#=> "３００"
p Suji.hankaku("三〇〇")
#=> 300
p Suji.kanji(8)
#=> "八"
p Suji.daiji("三")
#=> "参"
p Suji.type?(10)
#=> "半角"

```

文字列をひらがな、カタカナ、半角カタカタ、ローマ字のいずれかに変換できます（漢字は使えません）
多くのメソッドは`Moji`というクラスに備わっています。

```ruby
mojiretsu = "おすし　は　おいしい　です　ね。"
Moji.romaji(mojiretsu)
#=> "osushi wa oishii desu ne."
```

# このリンクを参考に → https://ja.wikipedia.org/wiki/%E5%A4%A7%E5%AD%97_(%E6%95%B0%E5%AD%97)

そして、10,300の場合は「1万3百」に変換されるようにしたいです

それぐらいかな

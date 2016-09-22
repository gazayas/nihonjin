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
# 今のところは、kanji_henkanは４桁まで変換できます
p Suji.kanji_henkan(150)
#=> "百五十"
p Suji.kanji_henkan(3521)
#=> "三千五百二十一"


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
```

kanji_henkan() と kanji() の名前を入れ替えるかな</br>
今のkanji_henkan()はもっと普通に使うかもしれないけど、type()とかでkanji()を使って、それの方は簡潔なのでもこのままでいいか...<br/>
そして、10,300の場合は「一万三百」とかに変換されるようにしたいです<br/>
そのあたりはまだです<br/>

## Moji 文字
文字列をひらがな、カタカナ、半角カタカタ、ローマ字のいずれかに変換できます（漢字は使えません）<br/>

```ruby
mojiretsu = "おすし　は　おいしい　です　ね。"
Moji.romaji(mojiretsu)
#=> "osushi wa oishii desu ne."
```

#<a href="https://ja.wikipedia.org/wiki/%E5%A4%A7%E5%AD%97_(%E6%95%B0%E5%AD%97)" target="_blank">このリンク</a>を参考にしてください

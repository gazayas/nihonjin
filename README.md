#nihonjin 日本人

このgemはまだできてないし、公開してないけど、次のことがしたいです。

３つのクラスを作りたい<br/>
`Suji`<br/>
`Moji`<br/>
`Toshi`<br/>

##Suji 数字
今はSujiが少しだけできてる<br/>
次のメソッドでは、どんな値でも入れていい<br/><br/>

```ruby
# 今のところは、kanji_henkanは20桁まで変換できます
p Suji.kanji_henkan(150)
#=> "百五十"
p Suji.kanji_henkan(3521)
#=> "三千五百二十一"
p Suji.kanji_henkan(27825672)
#=> "二千七百八十二万五千六百七十二"
p Suji.kanji_henkan(623_367_289_348)
#=> "六千二百三十三億六千七百二十八万九千三百四十八"
p Suji.kanji_henkan(56_004_223_746_273_373_565)
#=> "五千六百京四千二百二十三兆七千四百六十二億七千三百三十七万三千五百六十五"


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
p Suji.type?("１０")
#=> "全角"
p Suji.type?("１０")
#=> "漢字"
p Suji.type?("壱")
#=> "大字"


# to_iも使えます
# 尚、上にあるkanji_henkan()が返すような値ではto_iは使えません
p Suji.to_i("三〇一")
#=> 301
p Suji.to_i("３０１")
#=> 301
p Suji.to_i("参零壱")
#=> 301
```

*うまく動いてない。１つのテストだけがダメだ。
上は、20桁まで行けるって言うけど、実はもっと長い数字を変換できる。<br/>
バグをなくしてからまたreadmeを直すこと

10_000の場合は「一万」になってるけど、1_000は「千」だけになってる。<br/>
合ってるかどうか分からないけど、合ってるような気がするww<br/>
誰か教えてくださいww<br/>

<a href="http://www.geocities.jp/f9305710/kazu.html" target="_blank">リンク</a>

###<a href="https://ja.wikipedia.org/wiki/%E5%A4%A7%E5%AD%97_(%E6%95%B0%E5%AD%97)" target="_blank">このリンク</a>を参考にしてください

## Moji 文字

###「たのしいRuby」299ページにnkfのメソッドのオプションが書いてある。それを使って、to_katana(str)、to_hiragana(str) というようにメソッドを書くこと

`utf8_pass`ではEncodingという定数じゃなくてEncodingのクラスがstr_data[0]に代入されるので、そこで注意すること<br/>
定数の名前を変えた方がいいかな。とにかく上手いこと両方を使わないとややこしくなるかもしれない。<br/>

もし上手く変換されなかったら、エラーで対応すること

「ぢゃ」とか「みゅ」とかはまだ入れてない<br/>
この<a href="http://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q1163793136" target="_blank">リンクを見てください</a>

文字列をひらがな、カタカナ、半角カタカタ、ローマ字のいずれかに変換できます（漢字は使えません）<br/>

```ruby
Ruby on Railsで、`<span class="fg">水</span>`を書いてhoverしたら、ふりがなが出るようにしたい

mojiretsu = "おすし　は　おいしい　です　ね。"
Moji.romaji(mojiretsu)
#=> "osushi wa oishii desu ne."
```

<a href="http://www.whiteagle.net/" target="_blank">このサイト</a>のjavascriptを参照にしてください

## Toshi 年

##しないといけないこと
Suji.kanji_henkan()が呼ぶ def man(num), def oku(num) とかは大体同じメソッドなので、<br/>
def cho(num), def kei(num) を書くなら、その前にリファクトリングして同じメソッドを呼ぶようにしよう<br/><br/>

テストはあんまり綺麗じゃない<br/>
一つの方法を決めて分かりやすくて綺麗にすること

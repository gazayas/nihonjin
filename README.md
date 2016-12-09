#nihonjin 日本人 :sushi:

日本語をもっと気楽に扱うためのgemです:octocat:

##インストール
```
$ gem install nihonjin
```

## Moji 文字

### いちいちnkfのオプションを調べるのは面倒くさいから、`Moji`で簡単に定義することができます
```ruby
moji = Nihonjin::Moji.new
moji.hiragana("hiragana ni naru.")
#=> "ひらがな　に　なる。"
moji.hiragana("ヒラガナ　ニ　ナル。")
#=> "ひらがな　に　なる。"
moji.katakana("かたかな　に　なる")
#=> "カタカナ　ニ　ナル"
moji.hankaku_katakana("hankaku katakana ni naru")
#=> "ﾊﾝｶｸ　ｶﾀｶﾅ　ﾆ　ﾅﾙ"

# Rubyではstripはありますが、日本語の文字に対応していないです
# 次のメソッドを使うと便利です
moji.hashigiri("     端　に　ある　空白　を　切り落とす　　　　")
#=> "端　に　ある　空白　を　切り落とす"

# すべての空白を切り落とすこともできる
moji.kiru("余計な　空白　を　切り落とす")
#=> "余計な空白を切り落とす"



# 出力コードもシンボルとして定義できます
moji.hiragana("hiragana ni naru.", :shift_jis)
#=> "\x{82D0}\x{82E7}\x{82AA}\x{82C8}\x{8140}\x{82C9}\x{8140}\x{82C8}\x{82E9}\x{8142}"
Nihonjin::EncodingTypes
#=> {:utf_8=>"-w", :shift_jis=>"-s", :iso_2022_jp=>"-j", :euc=>"-e"}

# リテラルも渡すことができます
moji.hiragana("hiragana ni naru.", "-w", "--mac")
#=> "ひらがな　に　なる。"
moji.hiragana("hiragana ni naru.", "-w --mac")
#=> "ひらがな　に　なる。"
```


##Suji 数字
今はSujiが少しだけできてる<br/>
次のメソッドでは、どんな値でも入れていい<br/><br/>

```ruby
suji = Nihonjin::Suji.new
# 今のところは、kanji_henkanは20桁まで変換できます
p suji.kanji_henkan(150)
#=> "百五十"
p suji.kanji_henkan(3521)
#=> "三千五百二十一"
p suji.kanji_henkan(27825672)
#=> "二千七百八十二万五千六百七十二"
p suji.kanji_henkan(623_367_289_348)
#=> "六千二百三十三億六千七百二十八万九千三百四十八"
p suji.kanji_henkan(56_004_223_746_273_373_565)
#=> "五千六百京四千二百二十三兆七千四百六十二億七千三百三十七万三千五百六十五"


p suji.zenkaku(300)
#=> "３００"
p suji.hankaku("三〇〇")
#=> "300"

# kanji_henkanと違って、普通に数字をそのまま漢字に変換する
p suji.kanji(800)
#=> "八〇〇"
p suji.daiji("三")
#=> "参"

p Suji.type?(10)
#=> "半角"
p Suji.type?("１０")
#=> "全角"
p Suji.type?("十")
#=> "漢字"
p Suji.type?("壱")
#=> "大字"


# to_iも使えます
# 尚、上にあるkanji_henkan()が返すような値ではto_iは使えません
p suji.to_i("三〇一")
#=> 301
p suji.to_i("３０１")
#=> 301
p suji.to_i("参零壱")
#=> 301
```

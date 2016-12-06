require 'nkf'

module Nihonjin

  class Moji

    Hiragana = {
      kya: "きゃ",        kyu: "きゅ",        kyo: "きょ",
      sha: "しゃ",        shu: "しゅ", she: "しぇ", sho: "しょ",
      cha: "ちゃ",        chu: "ちゅ",        cho: "ちょ",
      dya: "ぢゃ",        dyu: "ぢゅ",        dyo: "ぢょ",
      nya: "にゃ",        nyu: "にゅ",        nyo: "にょ",
      hya: "ひゃ",        hyu: "ひゅ",        hyo: "ひょ",
      mya: "みゃ",        myu: "みゅ",        myo: "みょ",
      rya: "りゃ",        ryu: "りゅ",        ryo: "りょ",

      gya: "ぎゃ",        gyu: "ぎゅ",        gyo: "ぎょ",
      ja: "じゃ",         ju: "じゅ", je: "じぇ", jo: "じょ",
      jya: "じゃ",         jyu: "じゅ",       jyo: "じょ",
      bya: "びゃ",        byu: "びゅ",        byo: "びょ",

      pya: "ぴゃ",        pyu: "ピュ",        pyo: "ぴょ",

      tsu: "つ",
      tu: "つ",

      ka: "か", ki: "き", ku: "く", ke: "け", ko: "こ",
      sa: "さ", si: "し", shi: "し", si: "し", su: "す", se: "せ", so: "そ",
      ta: "た", chi: "ち", te: "て", to: "と",
      na: "な", ni: "に", nu: "ぬ", ne: "ね", no: "の",
      ha: "は", hi: "ひ", fu: "ふ", he: "へ", ho: "ほ",
      ma: "ま", mi: "み", mu: "む", me: "め", mo: "も",
      ya: "や",           yu: "ゆ",          yo: "よ",
      ra: "ら", ri: "り", ru: "る", re: "れ", ro: "ろ",
      wa: "わ", wi: "ゐ",           we: "ゑ", wo: "を",
      n: "ん", n_: "ん", # 「n_」はんに（範囲）とかを書くために。Issue #16を見てください

      va: "ゔぁ", vi: "ゔぃ", vu: "ゔ", ve: "ゔぇ", vo: "ゔぉ",
      ga: "が", gi: "ぎ", gu: "ぐ", ge: "げ", go: "ご",
      za: "ざ", ji: "じ", zu: "ず", ze: "ぜ", zo: "ぞ",
      da: "だ", di: "ぢ", du: "づ", de: "で", do: "ど",
                        dzu: "づ",
      ba: "ば", bi: "び", bu: "ぶ", be: "べ", bo: "ぼ",
      pa: "ぱ", pi: "ぴ", pu: "ぷ", pe: "ぺ", po: "ぽ",

      fa: "ふぁ", fi: "ふぃ", fe: "ふぇ", fo: "ふぉ",
                 di_: "でぃ",
      a: "あ", i: "い", u: "う", e: "え", o: "お",
                       wu: "う"
    }

    Small_hiragana = {
      ya: "ゃ",          yu: "ゅ",           yo: "ょ",
      a: "ぁ", i: "ぃ", u: "ぅ", e: "ぇ", o: "ぉ",
      tsu: "っ"
    }

    EncodingTypes = {
      utf_8: '-w',
      shift_jis: '-s',
      iso_2022_jp: '-j',
      euc: '-e'
    }

    Consonants = ["bb", "cc", "dd", "ff", "gg", "hh", "jj", "kk", "ll", "pp", "qq", "rr", "ss", "tt", "vv", "ww", "yy", "zz"]

    # これはちょっと見にくいから直せばいい
    # ところで[0]の方は英字で[1]の方は日本語
    Symbols = [[".", "。"], ["!", "！"], ["?", "？"], [",", "、"]]

    # NKFのオプションを#hiraganaの方で定義すれば、Moji.hiragana()を呼ぶだけで文字列が簡単に変換されます
    # たのしいRuby299ページを参照してください
    def hiragana(str, *options)
      
      options = setup options
      str_data = utf_8_pass(str)
      str = str_data[:string]
      str = str.downcase

      # "matte"みたいな文字列を「まって」に変えるために
      Consonants.each do |c|
        if str.match(c)
          str = str.gsub(c, ("っ" + c[0]))
        end
      end

      # 対象の文字列にはローマ字がある場合
      Hiragana.each do |key, value|
        re = Regexp.new(key.to_s)
        if str.match(re)
          str = str.gsub(re, Hiragana[key])
        end
      end

      # びっくりマークなどを日本語の文字にします
      Symbols.each do |symbol|
        str = str.gsub(symbol[0], symbol[1])
      end

      # 「x」を文字の前に入れることで、自由に小さいひらがなを定義することができる
      if str =~ /x/
        place = str =~ /x/
        str[place + 1] = Small_hiragana[Hiragana.key(str[place + 1])]
        str[place] = ""
      end

      # while文が良くないかもしれない
      # 最後に/([a-zA-Z])/にマッチしてしまったらエラーを返したいけど、
      # while文だと、もしそのエラーを生じるはずのものが次のwhile文に入っていたら、
      # while文を出ることはない。それは困る。
      while str =~ /([a-zA-Z])/
        place = str =~ (/[a-zA-Z]/)
        romaji_to_small_tsu(str, place)
      end

      str = kuhaku(str, :zenkaku)

      str = NKF.nkf(('-h1 ' + options), str)

      # もしoptionsを定義しなかったら、文字列のオリジナルの文字コードにします
      str.encode(str_data[:encoding].name) if options.empty?

      # raise error if str =~ /[a-zA-Z]/

      str

    end

    def hiragana!(str, *options)
      str.sub!(str, (hiragana(str, options)))
    end



    def katakana(str, *options)
      str = hiragana(str, options)
      options = setup options
      str_data = utf_8_pass(str)
      str = str_data[:string]
      str = NKF.nkf(('-h2 ' + options), str)
      str = str.encode(str_data[:encoding].name) if options.empty?
      str
    end

    def katakana!(str, *options)
      str.sub!(str, (katakana(str, options)))
    end



    def hankaku_katakana(str, *options)
      str = katakana(str, options)
      options = setup options
      str_data = utf_8_pass(str)
      str = str_data[:string]
      str = NKF.nkf(('-Z4 ' + options), str)
      str = str.encode(str_data[:encoding].name) if options.empty?
      str
    end

    def hankaku_katakana!(str, *options)
    end



    def romaji(str, encoding=:utf_8)

      # すべての文字をひらがなに統一してからローマ字に変換されます
      # カタカナなどが入っている時の対応
      str = hiragana(str, encoding)

      str_data = utf_8_pass(str)
      str = str_data[:string]

      Hiragana.each do |key, value|
        re = Regexp.new(value)
        if str.match(re)
          str = str.gsub(re, key.to_s)
        end
      end

      Symbols.each do |symbol|
        str = str.gsub(symbol[1], symbol[0])
      end

      while str =~ /っ/
        place = str =~ /っ/
        small_tsu_to_romaji(str, place)
      end

      str = kuhaku(str)

      # str = str.encode(str_data[:encoding].name) # ローマ字はshift_jisに変換できるかな...
      str.encode(str_data[:encoding].name)

    end

    def romaji!(str, encoding=:utf_8)
    end



    def kana_invert(str, *options)
      options = setup options
      str_data = utf_8_pass(str)
      str = str_data[:string]
      str = NKF.nkf(('-h3 ' + options), str)
      str = str.encode(str_data[:encoding].name) if options.empty?
      str
    end

    def kana_invert!(str, *options)
      str = str.sub!(str, (kana_invert(str, options)))
    end



    def kiru(str)
      if str.match(/　/)
        str = str.gsub(/　/, " ")
      end
      str.gsub(/\s/, "")
    end

    def kiru!(str)
      str = str.sub(str, kiru(str))
    end



    def hashigiri(str)
      if str.match(/^　/)
        str = str.sub(/^　/, " ")
      end
      if str.match(/　$/)
        str = str.sub(/　$/, " ")
      end
      str = str.strip
    end

    def hashigiri!(str)
      str = str.sub(str, hashigiri(str))
    end



    # 対象の文字列の空白を全角の空白にします
    # :zenkakuをoptionとして渡せば、すべての空白は全角の空白に変換されます
    def kuhaku(str, option=nil)
      str_data = utf_8_pass(str)
      str = str_data[:string]

      # :double というオプションを入れたい。nkfの-Z2のこと
      if option == :zenkaku
        str = str.gsub(/\s/, "　") # 全角に変える
      else
        str = str.gsub(/　/, " ") # 普通の空白に変える
      end
      str.encode(str_data[:encoding].name)
    end

    # #kuhakuの文字列を破壊的に変換します
    def kuhaku!(str, option=nil)
    end


    # 対象の文字列の全角と半角の空白を逆にします
    def kuhaku_invert(str)
      str_data = utf_8_pass(str)
      str = str_data[:string]

      str = str.split("")
      str = str.map do |s|
        if s =~ /\s/ # 半角であれば
          s = "　" # 全角に
        elsif s =~ /　/ # 全角であれば
          s = " " # 半角に
        else
          s
        end
      end
      new_str = String.new
      str.each do |s|
        new_str += s
      end
      new_str = new_str.encode(str_data[:encoding].name)
    end

    # #kuhaku_invertの文字列を破壊的に変換します
    def kuhaku_invert!(str)
    end



    private

    def setup(options)
      options = options.flatten
      options = options.map do |option|
        option = EncodingTypes[option] if option.class == Symbol
        option
      end
      options = options.join(' ')
      options = EncodingTypes[:utf_8] if options.empty?
      options
    end

    # utf-8でない文字列の対応としては、元のエンコーディングとutf-8バージョンの文字列を配列に格納して返します
    # #hiraganaとかのメソッドの処理が終われば、文字列の元のエンコーディングに戻します。
    def utf_8_pass(str)
      original_encoding = str.encoding
      str = str.encode("UTF-8")
      str_data = {
        string: str,
        encoding: original_encoding
      }
    end

    # 再帰的に対象の文字列に「っ」が何個か続いたら、「っ」の次の文字の（ローマ字の）子音を見つけて「っ」と代えます。
    # 「どっっかん！」を書いたら「dokkkan!」になる
    def small_tsu_to_romaji(str, place)
      if str[place + 1] =~ /[a-zA-Z]/
        str[place] = str[place + 1]
      else
        if str[place + 1] == "っ"
          str[place] = small_tsu_to_romaji(str, (place + 1))
        else # びっくりマークなどの場合
          str[place] = ""
        end
      end
    end

    # 動くけど動作が気になる
    # できたら変えた方がいいかもしれない
    # -1 じゃなくて + 1
    def romaji_to_small_tsu(str, place)
      if str[place - 1] =~ /っ/
        str[place] = "っ"
      elsif str[place - 1] == str[place] # 同じローマ字が続く場合
        romaji_to_small_tsu(str, (place - 1))
      elsif str[place + 1] == nil # "akkk"は「あっk」になってしまう。#hiraganaでエラーをraiseするように
        str[place]
      end
    end

  end

end

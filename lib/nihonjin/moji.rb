require 'nkf'
require 'nihonjin/options'

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
      sa: "さ", shi: "し", si: "し", su: "す", se: "せ", so: "そ",
      ta: "た", chi: "ち", te: "て", to: "と",
      na: "な", ni: "に", nu: "ぬ", ne: "ね", no: "の",
      ha: "は", hi: "ひ", fu: "ふ", he: "へ", ho: "ほ",
      ma: "ま", mi: "み", mu: "む", me: "め", mo: "も",
      ya: "や",           yu: "ゆ",          yo: "よ",
      ra: "ら", ri: "り", ru: "る", re: "れ", ro: "ろ",
      wa: "わ", wi: "ゐ",           we: "ゑ", wo: "を",
      n: "ん", n_: "ん", # 「n_」はんい（範囲）とかを書くために。Issue #16を見てください

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

    Consonants = ["bb", "cc", "dd", "ff", "gg", "hh", "jj", "kk", "ll", "pp", "qq", "rr", "ss", "tt", "vv", "ww", "yy", "zz"]

    # これはちょっと見にくいから直せばいい
    # ところで[0]の方は英字で[1]の方は日本語
    Symbols = [[".", "。"], ["!", "！"], ["?", "？"], [",", "、"], ["~", "〜"]]

    # 対象の文字列をnkfで、ひらがなに変換します。#nkf_passと「たのしいRuby」299ページを参照してください
    def hiragana(str, *options)
      
      need_to_change_encoding = check_encoding(options)
      options = setup options
      str_data = utf_8_pass(str)
      str = str_data[:string]
      str = str.downcase

      # "matte"みたいな文字列を「まって」に変換します
      Consonants.each do |c|
        if str.match(c)
          str = str.gsub(c, ("っ" + c[0]))
        end
      end

      # 対象の文字列にはローマ字がある場合ひらがなに変換します
      Hiragana.each do |key, value|
        re = Regexp.new(key.to_s)
        if str.match(re)
          str = str.gsub(re, Hiragana[key])
        end
      end

      # びっくりマークなどの記号を日本語の文字にします
      Symbols.each do |symbol|
        str = str.gsub(symbol[0], symbol[1])
      end

      # 「x」を文字の前に入れることで、小さいひらがなを定義することができます
      if str =~ /x/
        i = 0
        str_ary = str.split("")
        str_ary.each do |s|
          if s =~ /x/
            str[i + 1] = Small_hiragana[Hiragana.key(str[i + 1])]
          end
          i += 1
        end
        str = str.gsub("x", "")
      end

      # 上記Consonants.eachのコードで重なっている文字は小さい「っ」に変換されるけど、全部は変換されません
      # 子音が残ってしまえば、変換されます。
      if str =~ /[a-z]/
        i = 0
        str_ary = str.split("")
        str_ary.each do |s|
          if s =~ /っ/
            str[i + 1] = "っ" if str[i + 1] =~ /[a-z]/
          end
          i += 1
        end
      end

      # この時点で if /[a-z]/、エラーをthrowしてください
      # raise error if str =~ /[a-zA-Z]/

      # これは要るかどうか工夫すること
      # またオプションとしては定義できるようにしたらいいかどうか工夫すること
      str = kuhaku(str, :zenkaku) 

      str = NKF.nkf(('-h1 ' + options), str)
      str = str.encode(str_data[:encoding].name) if need_to_change_encoding
      str

    end

    def hiragana!(str, *options)
      str.sub!(str, (hiragana(str, options)))
    end



    def katakana(str, *options)
      str = hiragana(str, options)
      str = general_nkf_pass(str, '-h2', options)
    end

    def katakana!(str, *options)
      str.sub!(str, (katakana(str, options)))
    end



    def hankaku_katakana(str, *options)
      str = katakana(str, options)
      str = general_nkf_pass(str, '-Z4', options)
    end

    def hankaku_katakana!(str, *options)
      str.sub!(str, (hankaku_katakana(str, options)))
    end



    def kana_invert(str, *options)
      options = setup options
      str = general_nkf_pass(str, '-h3', options)
    end

    def kana_invert!(str, *options)
      str.sub!(str, (kana_invert(str, options)))
    end



    def romaji(str, encoding=:utf_8)

      need_to_change_encoding = check_encoding(encoding)
      str_data = utf_8_pass(str)

      # すべての文字をひらがなに統一してからローマ字に変換されます。カタカナなどが入っている時の対応
      str = hiragana(str, encoding)
      str = str.downcase

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

      # while文はちょっと気になる
      while str =~ /っ/
        place = str =~ /っ/
        small_tsu_to_romaji(str, place)
      end

      # 上記のHiragana.eachと重複しているのでProcを作ってHiraganaやSmall_hiraganaを引数として渡すかな
      Small_hiragana.each do |key, value|
        re = Regexp.new(value)
        if str.match(re)
          str = str.gsub(re, key.to_s)
        end
      end

      str = kuhaku(str)
      str = str.encode(str_data[:encoding].name) if need_to_change_encoding
      str

    end

    def romaji!(str, encoding=:utf_8)
      str.sub!(str, (romaji(str, encoding)))
    end


    #################################
    #                               #
    # 以降は空白を扱うためのメソッドです #
    #                               #
    #################################

    # 対象の文字列のすべての空白を切り落とす
    def kiru(str)
      if str.match(/　/)
        str = str.gsub(/　/, " ")
      end
      str.gsub(/\s/, "")
    end

    def kiru!(str)
      str.sub!(str, kiru(str))
    end


    # 対象の文字列の端にある空白を切り落とす
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
      str.sub!(str, hashigiri(str))
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
      str.sub!(str, kuhaku(str))
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
      str.sub!(str, kuhaku_invert(str))
    end



    private

    # optionsの中で新しい文字コードを定義すれば、nkfは文字列をそのエンコーディングにする
    # 定義していなければ、元のエンコーディングに変える必要があります
    def check_encoding(*options)
      options = options.flatten if options.class == Array
      need_to_change_encoding = true
      options.each do |option|
        EncodingTypes.each do |key, val|
          if option == key || option =~ Regexp.new(val)
            need_to_change_encoding = false
          end
        end
      end
      need_to_change_encoding
    end

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

    # utf-8でない文字列の対応としては、元のエンコーディングとutf-8バージョンの文字列を配列に格納して返します。
    # #hiraganaとかのメソッドの処理が終われば、文字列の元のエンコーディングに戻します
    # （エンコーディングを変えるオプションが定義していなければ）
    def utf_8_pass(str)
      original_encoding = str.encoding
      str = str.encode("UTF-8")
      str_data = {
        string: str,
        encoding: original_encoding
      }
    end

    # specific_optionは'-h2'、'-Z4'などのことを差します
    # 上記のメソッドで文字列、オプションのリテラル、そしてそれ以外のオプションを定義するだけで、
    # nkfの関数が呼び出されます
    def general_nkf_pass(str, specific_option, *options)
      need_to_change_encoding = check_encoding(options)
      options = setup options
      str_data = utf_8_pass(str)
      str = str_data[:string]
      str = NKF.nkf((specific_option + ' ' + options), str)
      str = str.encode(str_data[:encoding].name) if need_to_change_encoding
      str
    end

    # 再帰的に対象の文字列に「っ」が何個か続いたら、「っ」の次の文字の（ローマ字の）子音を見つけて「っ」と代えます。
    # 「どっっっかん！」を書いたら「dokkkkan!」になる
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

  end

end

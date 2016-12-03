require 'nkf'

class Moji

  # 特別な文字：
  # ji2: "ぢ", fa: "ファ", fi: "フィ", fe: "フェ", fo: "フォ", ディ: "di"
  # 小さい方も追加したです
  # 「ヰ」と「ヱ」の半角はないらしいです：
  # http://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q1024671115sad
  # https://ja.wikipedia.org/wiki/JIS_X_0201
  # その代り、半角の「エ」と「イ」を使ったらいいかな

  # 最後に「あ」〜「う」を置く理由は正規表現のためです
  # また、「じゃ」〜「じょ」が最初の方にあるのもそのため
  # 小さい文字も入れないとダメだ（「っ」や「ゅ」とか）
  HIRAGANA = {
    kya: "きゃ",        kyu: "きゅ",        kyo: "きょ",
    sha: "しゃ",        shu: "しゅ",        sho: "しょ",
    ja: "じゃ",         ju: "じゅ",         jo: "じょ",
    cha: "ちゃ",        chu: "ちゅ",        cho: "ちょ",
    ja2: "ぢゃ",        ju2: "ぢゅ",        jo2: "ぢょ", # この欄は要る？
    nya: "にゃ",        nyu: "にゅ",        nyo: "にょ",
    tsu: "つ",
    # あとは「ひゃ」とか「びゃ」とかはまだ。。。
    ka: "か", ki: "き", ku: "く", ke: "け", ko: "こ",
    sa: "さ", shi: "し", su: "す", se: "せ", so: "そ",
    ta: "た", chi: "ち", te: "て", to: "と",
    na: "な", ni: "に", nu: "ぬ", ne: "ね", no: "の",
    ha: "は", hi: "ひ", fu: "ふ", he: "へ", ho: "ほ",
    ma: "ま", mi: "み", mu: "む", me: "め", mo: "も",
    ya: "や",           yu: "ゆ",          yo: "よ",
    ra: "ら", ri: "り", ru: "る", re: "れ", ro: "ろ",
    wa: "わ", wi: "ゐ",           we: "ゑ", wo: "を",
    n: "ん",

    v: "ゔ",
    ga: "が", gi: "ぎ", gu: "ぐ", ge: "げ", go: "ご",
    za: "ざ", ji: "じ", zu: "ず", ze: "ぜ", zo: "ぞ",
    da: "だ", ji2: "ぢ", dzu: "づ", de: "で", do: "ど",

    ba: "ば", bi: "び", bu: "ぶ", be: "べ", bo: "ぼ",
    pa: "ぱ", pi: "ぴ", pu: "ぷ", pe: "ぺ", po: "ぽ",

    fa: "ふぁ", fi: "ふぃ", fe: "ふぇ", fo: "ふぉ",
    di: "でぃ",
    a: "あ", i: "い", u: "う", e: "え", o: "お",

  }

  KATAKANA_HANKAKU = {

    ka: "ｶ", ki: "ｷ", ku: "ｸ", ke: "ｹ", ko: "ｺ",
    sa: "ｻ", shi: "ｼ", su: "ｽ", se: "ｾ", so: "ｿ",
    ta: "ﾀ", chi: "ﾁ", tsu: "ﾂ", te: "ﾃ", to: "ﾄ",
    na: "ﾅ", ni: "ﾆ", nu: "ﾇ", ne: "ﾈ", no: "ﾉ",
    ha: "ﾊ", hi: "ﾋ", fu: "ﾌ", he: "ﾍ", ho: "ﾎ",
    ma: "ﾏ", mi: "ﾐ", mu: "ﾑ", me: "ﾒ", mo: "ﾓ",
    ya: "ﾔ",           yu: "ﾕ",          yo: "ﾖ",
    ra: "ﾗ", ri: "ﾘ", ru: "ﾙ", re: "ﾚ", ro: "ﾛ",
    wa: "ﾜ", wi: "",           we: "", wo: "ｦ",
    n: "",

    v: "ｳﾞ",
    ga: "ｶﾞ", gi: "ｷﾞ", gu: "ｸﾞ", ge: "ｹﾞ", go: "ｺﾞ",
    za: "ｻﾞ", ji: "ｼﾞ", zu: "ｽﾞ", ze: "ｾﾞ", zo: "ｿﾞ",
    da: "ﾀﾞ", ji2: "ﾁﾞ", dzu: "ﾂﾞ", de: "ﾃﾞ", do: "ﾄﾞ",
    ba: "ﾊﾞ", bi: "ﾋﾞ", bu: "ﾌﾞ", be: "ﾍﾞ", bo: "ﾎﾞ",

    pa: "ﾊﾟ", pi: "ﾋﾟ", pu: "ﾌﾟ", pe: "ﾍﾟ", po: "ﾎﾟ",

    fa: "ﾌｧ", fi: "ﾌｨ", fe: "ﾌｪ", fo: "ﾌｫ",
    di: "ﾃﾞｨ",
    a: "ｱ", i: "ｲ", u: "ｳ", e: "ｴ", o: "ｵ"
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
  Symbols = [[".", "。"], ["!", "！"], ["?", "？"]]


  # 対象の文字列の空白を全角の空白にします
  # :zenkakuをoptionとして渡せば、すべての空白は全角の空白に変換されます
  def self.kuhaku(str, option=nil)
    str_data = utf8_pass(str)
    str = str_data[1]

    # :double というオプションを入れたい。nkfの-Z2のこと
    if option == :zenkaku
      str = str.gsub(/\s/, "　") # 全角に変える
    else
      str = str.gsub(/　/, " ") # 普通の空白に変える
    end
    str.encode(str_data[0])
  end

  # #kuhakuの文字列を破壊的に変換します
  def self.kuhaku!(str, option=nil)
  end


  # 対象の文字列の全角と半角の空白を逆にします
  def self.kuhaku_invert(str)
    str_data = utf8_pass(str)
    str = str_data[1]

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
    new_str.encode(str_data[0])
  end

  # #kuhaku_invertの文字列を破壊的に変換します
  def self.kuhaku_invert!(str)
  end



  # NKFのオプションを#hiraganaの方で定義すれば、Moji.hiragana()を呼ぶだけで文字列が簡単に変換されます
  # たのしいRuby299ページを参照してください
  def self.hiragana(str, *options)
    options = options.map do |option|
      option = EncodingTypes[option] if option.class == Symbol
      option
    end
    options = options.flatten # hiragana!の*optionsが二重してしまうから
    str_data = utf8_pass(str)
    str = str_data[1]
    options = options.join(' ') # optionsは空であっても文字列に変換されます
    options = EncodingTypes[:utf_8] if options.empty?

    str = str.downcase

    Consonants.each do |c|
      if str.match(c)
        str = str.gsub(c, ("っ" + c[0]))
      end
    end

    # ローマ字の場合
    HIRAGANA.each do |key, value|
      re = Regexp.new(key.to_s)
      if str.match(re)
        str = str.gsub(re, HIRAGANA[key])
      end
    end

    Symbols.each do |symbol|
      str = str.gsub(symbol[0], symbol[1])
    end

    str = NKF.nkf(('-h1 ' + options), str)
    str = kuhaku(str, :zenkaku)
  end

  def self.hiragana!(str, *options)
    str.sub!(str, (hiragana(str, options)))
  end



  def self.katakana(str, *options)

    str = hiragana(str, options)

    options = options.map do |option|
      if option.class == Symbol
        option = EncodingTypes[option]
      end
      option
    end
    options = options.flatten # hiragana!の*optionsが二重してしまうから
    str_data = utf8_pass(str)
    str = str_data[1]
    options = options.join(' ') # optionsは空であっても文字列に変換されます
    options = EncodingTypes[:utf_8] if options.empty?

    str = NKF.nkf(('-h2 ' + options), str)

  end

  def self.katakana!(str, *options)
    str.sub!(str, (katakana(str, options)))
  end



  def self.hankaku_katakana(str, *options)
  end

  def self.hankaku_katakana!(str, *options)
  end



  def self.romaji(str)
  end

  def self.romaji!(str)
  end



  def self.kana_invert(str, *options)

    options = options.map do |option|
      if option.class == Symbol
        option = EncodingTypes[option]
      end
      option
    end
    options = options.flatten # hiragana!の*optionsが二重してしまうから
    str_data = utf8_pass(str)
    str = str_data[1]
    options = options.join(' ') # optionsは空であっても文字列に変換されます
    options = EncodingTypes[:utf_8] if options.empty?

    str = NKF.nkf(('-h3 ' + options), str)

  end

  def self.kana_invert!(str, *options)
    str = str.sub!(str, (kana_invert(str, options)))
  end



  def self.kiru(str)
    if str.match(/　/)
      str = str.gsub(/　/, " ")
    end
    str.gsub(/\s/, "")
  end

  def self.kiru!(str)
    str = str.sub(str, kiru(str))
  end



  def self.hashigiri(str)
    if str.match(/^　/)
      str = str.sub(/^　/, " ")
    end
    if str.match(/　$/)
      str = str.sub(/　$/, " ")
    end
    str = str.strip
  end

  def self.hashigiri!(str)
    str = str.sub(str, hashigiri(str))
  end



  private

  # utf-8でない文字列の対応としては、元のエンコーディングとutf-8バージョンの文字列を配列に格納して返します
  # #hiraganaとかのメソッドの処理が終われば、文字列の元のエンコーディングに戻します。
  def self.utf8_pass(str)
    original_encoding = str.encoding
    str = str.encode("UTF-8")
    str_data = [original_encoding, str]
  end

end

require 'nkf' # ここかなww

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
    ja2: "ぢゃ",        ju2: "ぢゅ",        jo2: "ぢょ",
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

    KATAKANA = {
    ka: "カ", ki: "キ", ku: "ク", ke: "ケ", ko: "コ",
    sa: "サ", shi: "シ", su: "ス", se: "セ", so: "ソ",
    ta: "タ", chi: "チ", tsu: "ツ", te: "テ", to: "ト",
    na: "ナ", ni: "ニ", nu: "ヌ", ne: "ネ", no: "ノ",
    ha: "ハ", hi: "ヒ", fu: "フ", he: "ヘ", ho: "ホ",
    ma: "マ", mi: "ミ", mu: "ム", me: "メ", mo: "モ",
    ya: "ヤ",           yu: "ユ",          yo: "ヨ",
    ra: "ラ", ri: "リ", ru: "ル", re: "レ", ro: "ロ",
    wa: "ワ", wi: "ヰ",           we: "ヱ", wo: "ヲ",
    n: "ン",

    v: "ヴ",
    ga: "ガ", gi: "ギ", gu: "グ", ge: "ゲ", go: "ゴ",
    za: "ザ", ji: "ジ", zu: "ズ", ze: "ゼ", zo: "ゾ",
    da: "ダ", ji2: "ジ", dzu: "ヅ", de: "デ", do: "ド",
    ba: "バ", bi: "ビ", bu: "ブ", be: "ベ", bo: "ボ",

    pa: "パ", pi: "ピ", pu: "プ", pe: "ペ", po: "ポ",

    fa: "ファ", fi: "フィ", fe: "フェ", fo: "フォ",
    di: "ディ",
    a: "ア", i: "イ", u: "ウ", e: "エ", o: "オ"
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

  def self.kuhaku!(str, option=nil)
  end

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

  def self.kuhaku_invert!(str)
  end

  # NKFのオプションを#hiraganaの方で定義すれば、Moji.hiragana()を呼ぶだけで文字列が簡単に変換されます
  # たのしいRuby299ページを参照してください
  def self.hiragana(str, *options)

    str = str.downcase

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

    # ローマ字の場合
    HIRAGANA.each do |key, value|
      re = Regexp.new(key.to_s)
      if str.match(re)
        str = str.gsub(re, HIRAGANA[key])
      elsif str.match(".")
        str = str.gsub(".", "。")
      end
    end

    str = NKF.nkf(('-h1 ' + options), str)
    str = kuhaku(str, :zenkaku)

  end

  def self.hiragana!(str, *options)
    str.sub!(str, (hiragana(str, options)))
  end

  def self.katakana(str, *options)
  end

  def self.katakana!(str, *options)
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
    # str = NKF.nkf('-h3' + options', str)
  end

  def self.kana_invert!(str, *options)
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

  # utf-8でない文字列の対応としては、元のエンコーディングとutf-8バージョンの文字列を配列に格納する
  def self.utf8_pass(str)
    original_encoding = str.encoding
    str = str.encode("UTF-8")
    str_data = [original_encoding, str]
  end

end

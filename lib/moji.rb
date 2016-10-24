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
    # あとは「ひゃ」とか「びゃ」とかはまだ。。。
    ka: "か", ki: "き", ku: "く", ke: "け", ko: "こ",
    sa: "さ", shi: "し", su: "す", se: "せ", so: "そ",
    ta: "た", chi: "ち", tsu: "つ", te: "て", to: "と",
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

  def self.kuhaku(str, option=nil)
    if option == :zenkaku
      str = str.gsub(/\s/, "　") # 全角に変える
    else
      str = str.gsub(/　/, " ") # 普通の空白に変える
    end
  end

  def self.kuhaku_invert(str)
    str = str.split("")
    str.each do |s|
      if s =~ /\s/
        s = s.sub(/\s/, "　") # 全角に
      elsif s =~ /　/
        s = s.sub(/　/, " ") # 半角に
      end
    end
    new_str = String.new
    str.each do |s|
      new_str += s
    end
    new_str
  end

  # NKFのオプションをメソッドの方で定義すればユーザには使いやすくなります
  # たのしいRuby299ページを参照してください
  def self.hiragana(str, *options)
    options = "-w" if options.empty?
    # カタカナの場合
    options = options.join(" ") if options.class == Array
    p options
    str = NKF.nkf("-h1 #{options}", str)
    # ローマ字の場合
    HIRAGANA.each do |key, value|
      re = Regexp.new(key.to_s)
      if str.match(re)
        str = str.gsub(re, HIRAGANA[key])
      end
    end
    str = kuhaku(str, :zenkaku)
  end

  def self.hiragana!(str, option='-w')
    str.sub!(str, (hiragana(str, option)))
  end

  def self.katakana(str, option=nil)
    if option == :hankaku
      # 半角のカタカナを返す
    else
      # 普通のカタカナを返す
    end
  end

  def self.kana_invert(str, option='-w')
    # str = NKF.nkf("-h3, #{option}", str)
  end
  
  def self.romaji(str)
  end

end

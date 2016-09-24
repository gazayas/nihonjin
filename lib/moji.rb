class Moji

  # 特別な文字：
  # ji2: "ぢ", fa: "ファ", fi: "フィ", fe: "フェ", fo: "フォ", ディ: "di"

  HIRAGANA = {
    a: "あ", i: "い", u: "う", e: "え", o: "お",
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

    fa: "ふぁ", fi: "ふぃ", fe: "ふぇ", fo: "ふぉ"
    di: "でぃ"
  }

    KATAKANA = {
    a: "ア", i: "イ", u: "ウ", e: "エ", o: "オ",
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

    fa: "ファ", fi: "フィ", fe: "フェ", fo: "フォ"
    di: "ディ"
  }

  # インスタンスを作らずにMojiのクラスが使えるようにしたいから、self.を追加しました
  def self.kuhaku(str, option=nil)
    if option == :zenkaku
      str = str.gsub(/\s/, "　")
    else
      str = str.gsub(/　/, " ")
    end
  end

  def self.hiragana(str)
  end

  def self.katakana(str, option=nil)
    if option == :hankaku
      # 半角のカタカナを返す
    else
      # 普通のカタカナを返す
    end
  end
  
  def self.romaji(str)
  end

end

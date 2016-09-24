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

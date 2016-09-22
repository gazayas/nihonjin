class Suji

  # カンマ入る時の対応

  HANKAKU = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  ZENKAKU = ["０", "１" , "２", "３", "４", "５", "６", "７", "８", "９"]
  KANJI = ["〇", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
  DAIJI = ["零", "壱", "弐", "参", "肆", "伍", "陸", "漆", "捌", "玖"]
  DAISU = {
    10 => "十",
    100 => "百",
    1000 => "千",
    1_0000 => "万",
    1_0000_0000 => "億",
    1_0000_0000_0000 => "兆",
    1_0000_0000_0000_0000 => "京",
    1_0000_0000_0000_0000_0000 => "垓",
    1_0000_0000_0000_0000_0000_0000 => "𥝱"
  }
  # 大数の読み方もあればいいかも

  def self.hankaku(num)
    num = num.to_s
    type = type?(num)
    return num.to_i if type == "半角"
    num = converter(num, type, HANKAKU)
    # num.to_i # hankakuで特別の戻り値；その他は文字列を返します
  end
  
  def self.zenkaku(num)
    num = num.to_s
    type = type?(num)
    return num if type == "全角"
    num = converter(num, type, ZENKAKU)
  end

  def self.kanji(num)
    num = num.to_s
    type = type?(num)
    return num if type == "漢字"
    num = converter(num, type, KANJI)
  end

  def self.daiji(num)
    num = num.to_s
    type = type?(num)
    return num if type == "大字"
    num = converter(num, type, DAIJI)
  end

  # ユーザが使えるように、"全角"、"漢字"などを返すことができるようにすること
  def self.type?(num)
    num = num.to_s
    constants = [HANKAKU, ZENKAKU, KANJI, DAIJI]
    type = nil
    constants.each do |constant|
      10.times do |n|
        regexp = Regexp.new(constant[n].to_s)
        if num.match(regexp)
          type = constant
        end
      end
    end
    if type == ZENKAKU
      "全角"
    elsif type == KANJI
      "漢字"
    elsif type == DAIJI
      "大字"
    else
      "半角"
    end
  end

  def self.kanji_henkan(num)
    # どんなタイプであっても変換されるようにする
    num = hankaku(num)
    num = num.to_s

    # そして実際に変換する
    if num.length == 1
      num = kanji(num)
    elsif num.length == 2
      num = ju(num)
    elsif num.length == 3
      num = hyaku(num)
    elsif num.length == 4
      num = sen(num)
    elsif num.length >= 5 && num.length <= 8
      num = man(num)
    end
  end

  private

  def self.converter(num, type, result_type)
    case type
    when "全角"
      type = ZENKAKU
    when "漢字"
      type = KANJI
    when "大字"
      type = DAIJI
    else
      type = HANKAKU
    end
    10.times do |n|
      regexp = Regexp.new(type[n].to_s)
      num = num.gsub(regexp, result_type[n].to_s)
    end
    num
  end

  # １〜２桁の数字を正しい漢字に変換する
  def self.ju(num)
    num = num.split("")

    # 次の条件が満たされます
    # （尚、１桁の場合もjuで対応します。空というのは「00」の場合です）
    # 十、十一、二十、二十一、一、空
    if num[0] == "1" && num[1] == "0" # 十
      num = "十"
    elsif num[0] == "1" && num[1] != "0" # 十一
      num[0] = "十"
      num[1] = kanji(num[1])
    elsif (num[0] != "0" && num != "1") && num[1] == "0" # 二十
      num[0] = kanji(num[0])
      num[1] = "十"
    elsif (num[0] != "0" && num != "1") && num[1] != "0" # 二十一
      num = num.unshift(num[0])
      num[0] = kanji(num[0])
      num[1] = "十"
      num[2] = kanji(num[2])
    elsif num[0] == "0" && num[1] != "0" # 一
      num[0] = ""
      num[1] = kanji(num[1])
    elsif num[0] == "0" && num[1] == "0" # 空
      num = ""
    end

    new_str = String.new
    if num.instance_of? Array
      num.each do |digit|
        new_str += digit
      end
      num = new_str
    end

    num

  end

  # ３桁の数字を正しい漢字に変換する
  def self.hyaku(num)

    num = num.split("")
    tenth_place = (num[-2] + num[-1])
    tenth_place = ju(tenth_place) # 値によって長さは変わることはあります
    # 次の条件が満たされます
    # 百、二百、空
    # 尚、「十」の位置以降はju()で計算されますので、先にそのメソッドを呼びます
    if num[0] == "1" # 百
      num[0] = "百"
      num = num[0] + tenth_place
    elsif num[0] == "0" # 空
      num[0] = ""
      num = num[0] + tenth_place
    elsif (num[0] != "1" && num[0] != "0") # 二百
      num = num.unshift(num[0])
      num[0] = kanji(num[0])
      num[1] = "百"
      num = num[0] + num[1] + tenth_place
    end

    num

  end

  # ４桁の数字を垂らしい漢字に変換する
  def self.sen(num)
    num = num.split("")
    hundreth_place = (num[-3] + num[-2] + num[-1])
    hundreth_place = hyaku(hundreth_place)

    # 次の条件が満たされます
    if num[0] == "1"
      num[0] = "千"
      num = num[0] + hundreth_place
    else
      num = num.unshift(num[0])
      num[0] = kanji(num[0])
      num[1] = "千"
      num = num[0] + num[1] + hundreth_place
    end

    num

  end

  # ５〜８桁の数字を正しい漢字に変換する
  def self.man(num)
  end

end
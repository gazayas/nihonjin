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

  # ２桁の数字を正しい漢字の変換する
  def self.ju(num)
    num = num.split("")
    if num[0] == "1" && num[1] == "0" # 普通に"10"の場合
      num = "十"
    elsif num[0] == "1" && num[1] != "0" # "15"などの場合
      num[0] = "十"
      num[1] = kanji(num[1])
    elsif num[0] == "0" && num[1] != "0" # 101などの場合
      num[0] = ""
      num[1] = kanji(num[1])
    elsif num[0] == "0" && num[1] == "0" # 100などの場合、最後の２桁を丸ごと消す
      num = ""
    elsif num.length == 1
      num = kanji(num[0]) # １桁の場合、普通に漢字に変換する。これをif文の前の方に入れた方がいいかな
    else # "35"などの場合
      num = num.unshift(num[0])
      num[0] = kanji(num[0])
      num[1] = "十"
      if num[2] == "0" # もし"30"になっていたら、最後の"0"を消す
        num[2] = ""
      else
        num[2] = kanji(num[2])
      end
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

  # ３桁の数字を正しい漢字の変換する
  def self.hyaku(num)
    num = hankaku(num)
    num = num.to_s
    num = num.split("")
    tenth_place = (num[-2] + num[-1])
    tenth_place = ju(tenth_place) # 値によって長さは変わることはあります
    if num[0] == "1" && num[1] == "0" && num[2] == "0"
      num = "百"
    elsif num[0] == "1"
      num[0] = "百"
    else
      num = num.unshift(num[0])
      num[0] = kanji(num[0])
      num[1] = "百"
      num[2] = kanji(num[2])
    end
    new_str = String.new
    if num[0] == "百"
      new_str = num[0] + tenth_place
    elsif num[0] != "百"
      new_str = num[0] + num[1] + tenth_place
    end
    num = new_str unless num.empty?
    num
  end

  # ４桁の数字を正しい漢字の変換する
  # def self.sen(num)
  # end

  # ５〜８桁の数字を正しい漢字に変換する
  # def self.man(num)
  # end

end
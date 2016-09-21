class Suji

  # カンマ入る時の対応

  HANKAKU = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  ZENKAKU = ["０", "１" , "２", "３", "４", "５", "６", "７", "８", "９"]
  KANJI = ["〇", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
  DAIJI = ["零", "壱", "弐", "参", "肆", "伍", "陸", "漆", "捌", "玖"]
  DAISU = ["十", "百", "千", "万", "億", "兆", "京", "垓", "𥝱"]
  # 大数の読み方もあればいいかも

  def self.hankaku(num)
    # ここに num = num.to_s で self.type? の１行目の方を消すこと？
    type = self.type?(num)
    if type == "半角"
      return num.to_i
    end
    num = self.converter(num, type, HANKAKU)
    num.to_i
  end
  
  def self.zenkaku(num)
    num = num.to_s # 半角の場合
    type = self.type?(num)
    if type == "全角"
      return num
    end
    num = self.converter(num, type, ZENKAKU)
  end

  def self.kanji(num)
    num = num.to_s
    type = self.type?(num)
    if type == "漢字"
      return num
    end
    num = self.converter(num, type, KANJI)
  end

  def self.daiji(num)
    num = num.to_s
    type = self.type?(num)
    if type == "大字"
      return num
    end
    num = self.converter(num, type, DAIJI)
  end

  # ユーザが使えるように、"全角"、"漢字"などを返すようにすること
  def self.type?(num)
    num = num.to_s # これは要る？気になる
    constants = [HANKAKU, ZENKAKU, KANJI, DAIJI]
    type = nil
    constants.each do |constant|
      10.times do |n|
        regexp_definer = constant # これは要る？
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

end




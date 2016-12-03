module Nihonjin

  class Suji

    HANKAKU = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    ZENKAKU = ["０", "１" , "２", "３", "４", "５", "６", "７", "８", "９"]
    KANJI = ["〇", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
    DAIJI = ["零", "壱", "弐", "参", "肆", "伍", "陸", "漆", "捌", "玖"]
    DAISU = ["万", "億", "兆", "京", "垓", "𥝱", "穣", "溝", "澗", "正", "載", "極"]
    # "恒河沙", "阿僧祇", "那由他", "不可思議", "無量大数" => こういうのを入れたかったら、扱いが変わらないとダメだ（長さは1じゃないから）
    
    # 大数の読み方もあればいいかな
    # メソッドの引数にはカンマが入っている時の対応

    # ユーザも使えるようにpublicにしました
    def type?(num)
      num = num.to_s
      constants = [HANKAKU, ZENKAKU, KANJI, DAIJI]
      type = nil
      constants.each do |constant|
        10.times do |n|
          regexp = Regexp.new(constant[n].to_s)
          if num.match(regexp)
            type = constant
            break
          end
        end
      end
      if type == ZENKAKU
        "全角"
      elsif type == KANJI
        "漢字"
      elsif type == DAIJI
        "大字"
      elsif type == HANKAKU
        "半角"
      else
        ""
      end
    end

    def to_i(num)
      return num unless !(num.instance_of? Integer)
      num = hankaku(num)
      num.to_i
    end

    def hankaku(num)
      type = type?(num)
      return num.to_i if type == "半角"
      num = converter(num, type, HANKAKU)    
    end

    def zenkaku(num)
      type = type?(num)
      return num if type == "全角"
      num = converter(num, type, ZENKAKU)
    end

    def kanji(num)
      type = type?(num)
      return num if type == "漢字"
      num = converter(num, type, KANJI)
    end

    def daiji(num)
      type = type?(num)
      return num if type == "大字"
      num = converter(num, type, DAIJI)
    end

    def kanji_henkan(num)
      num = num.to_s
      if num == "0"
        return kanji(num)
      end
      comma_place = 4
      comma_counter = 0
      loop do
        if comma_place > (num.length)
          break
        else
          num[-(comma_place + comma_counter), 0] = "," if num[-(comma_place + comma_counter)] != nil
          comma_place += 4
          comma_counter += 1
        end
      end
      split_num = num.split(",")
      split_num.shift if split_num[0] == ""
      
      kanji_array = split_num.map do |n|
        case n.length
        when 1
          ichi(n)
        when 2
          ju(n)
        when 3
          hyaku(n)
        when 4
          sen(n)
        end
      end

      num = String.new
      kanji_array.length.times do |n|
        num[0, 0] += DAISU[n] + kanji_array[-(n + 1)]
      end
      DAISU.each do |ds|
        regexp_str = "^" + ds
        regexp = Regexp.new(regexp_str)
        if num =~ regexp
          num[0] = ""
        end
      end

      # 数字は「一兆億万」とかにならなくて「一兆」みたいになるように
      num.length.times do |n|
        DAISU.each do |ds|
          if num[n] == ds
            if num[n + 1] == DAISU[(DAISU.index(ds)) - 1]
              num[n + 1] = ""
            end
          end
        end
      end
      
      # p split_num
      num

    end



    private

    def converter(num, type, result_type)
      num = num.to_s
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

    def ichi(num)
      if num == "0"
        ""
      else
        num = kanji(num)
      end
    end

    # １〜２桁の数字を正しい漢字に変換する
    def ju(num)
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
    def hyaku(num)

      num = num.split("")
      tenth_place = (num[-2] + num[-1])
      tenth_place = ju(tenth_place)
      # 次の条件が満たされます
      # 百、二百、空
      # 尚、「十」の位置以降はju()で計算されますので、先にそのメソッドを呼んで、戻り値を「百」の尾に連結します
      if num[0] == "1" # 百
        num[0] = "百"
        num = num[0] + tenth_place
      elsif num[0] == "0" # 空 （num[0]が要らなくなるのでtenth_placeだけをnumに代入します）
        num = tenth_place
      elsif (num[0] != "1" && num[0] != "0") # 二百
        num = num.unshift(num[0])
        num[0] = kanji(num[0])
        num[1] = "百"
        num = num[0] + num[1] + tenth_place
      end

      num

    end

    # ４桁の数字を正しい漢字に変換する
    def sen(num)
      num = num.split("")
      hundreth_place = (num[-3] + num[-2] + num[-1])
      hundreth_place = hyaku(hundreth_place)

      # 次の条件が満たされます（hyaku(num)と同じく）
      # 千、一千、空
      if num[0] == "1" # 千
        num[0] = "千"
        num = num[0] + hundreth_place
      elsif num[0] == "0" # 空（num[0]が要らなくなるのでhundredth_placeだけをnumに代入します）
        num = hundreth_place
      else # 一千など
        num = num.unshift(num[0])
        num[0] = kanji(num[0])
        num[1] = "千"
        num = num[0] + num[1] + hundreth_place
      end

      num

    end

  end

end

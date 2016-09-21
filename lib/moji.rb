class Moji

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

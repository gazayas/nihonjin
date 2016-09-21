require 'spec_helper'

describe Suji do

  
  context 'typeを返すこと' do
    it '整数であって"半角"を返す' do
      type = Suji.type?(47)
      expect(type).to eq "半角"
    end
    it '文字列であって"半角"を返すこと' do
      type = Suji.type?("47")
      expect(type).to eq "半角"
    end
    it '"全角"を返すこと' do
      type = Suji.type?("４７")
      expect(type).to eq "全角"
    end
    it '"漢字"を返すこと' do
      type = Suji.type?("四七")
      expect(type).to eq "漢字"
    end
    it '"大字"を返すこと' do
      type = Suji.type?("肆漆")
    end
  end
  
  # 全てのtypeから全てのtypeに変換されるようなテストを書いた方がいいかも知らない（０＿０）大変かもしれないwww
  context '全角に変換するテスト' do
    it '半角から変換されること' do
      suji = Suji.zenkaku(47)
      expect(suji).to eq "４７"
    end
    it '漢字から変換されること' do
      # 漢字のテストを変えないと。。。「四十七」に対応できるように /^十/なら消されないけど、そのほかの場合十は消される
      suji = Suji.zenkaku("四七") 
      expect(suji).to eq "４７"
    end
  end

  context 'kanji_henkanは２桁までうまく動作してること' do
    it '１桁の数字は漢字に変換されること' do
      suji = Suji.kanji_henkan("4")
      expect(suji).to eq "四"
    end
    it '"10"は"十"に変換されること' do
      suji = Suji.kanji_henkan("10")
      expect(suji).to eq "十"
    end
    it '"15"は"十五"に変換されること' do
      suji = Suji.kanji_henkan("15")
      expect(suji).to eq "十五"
    end
    it '"47"は"四十七"に変換されること' do
      suji = Suji.kanji_henkan("47")
      expect(suji).to eq "四十七"
    end
  end

  context 'kanji_henkanは３ 桁までうまく動作してること' do
    it '"100"は"百"に変換されること' do
      suji = Suji.kanji_henkan("100")
      expect(suji).to eq "百"
    end
    it '"201"は"二百一"に変換されること' do
      suji = Suji.kanji_henkan("201")
      expect(suji).to eq "二百一"
    end
    it '"310"は"三百十"を返すこと' do
      suji = Suji.kanji_henkan("310")
      expect(suji).to eq "三百十"
    end
    it '"315"は"三百十五"を返すこと' do
      suji = Suji.kanji_henkan("315")
      expect(suji).to eq "三百十五"
    end
    it '"447"は"四百四十七"を返すこと' do
      suji = Suji.kanji_henkan("447")
      expect(suji).to eq "四百四十七"
    end
  end

end
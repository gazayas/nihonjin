require 'spec_helper'

describe Suji do

  # 次は kanji_henkanが返すような値を整数にすること...
  context 'to_iは整数を返すこと' do
    it '整数は整数を返すこと' do
      suji = Suji.to_i(10)
      expect(suji).to eq 10
    end
    it '半角は整数を返すこと' do
      suji = Suji.to_i("10")
      expect(suji).to eq 10
    end
    it '全角は整数を返すこと' do
      suji = Suji.to_i("１０")
      expect(suji).to eq 10
    end
    it '漢字は整数を返すこと' do
      suji = Suji.to_i("七九一")
      expect(suji).to eq 791
    end
    it '大字は整数を返すこと' do
      suji = Suji.to_i("壱弐参")
      expect(suji).to eq 123
    end
  end

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




  # kanji_henkanのテストをちょっと考え直さないとダメだなww


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

  context 'kanji_henkanは３桁までうまく動作してること' do
    it '100は"百"に変換されること' do
      suji = Suji.kanji_henkan(100)
      expect(suji).to eq "百"
    end
    it '201は"二百一"に変換されること' do
      suji = Suji.kanji_henkan(201)
      expect(suji).to eq "二百一"
    end
    it '310は"三百十"を返すこと' do
      suji = Suji.kanji_henkan(310)
      expect(suji).to eq "三百十"
    end
    it '315は"三百十五"を返すこと' do
      suji = Suji.kanji_henkan(315)
      expect(suji).to eq "三百十五"
    end
    it '447は"四百四十七"を返すこと' do
      suji = Suji.kanji_henkan(447)
      expect(suji).to eq "四百四十七"
    end
  end

  context 'kanji_henkanは４桁までうまく動くこと' do
    it '1000は"千"に変換されること' do
      suji = Suji.kanji_henkan(1000)
      expect(suji).to eq "千"
    end
    it '10001は"千一"に変換されること' do
      suji = Suji.kanji_henkan(1001)
      expect(suji).to eq "千一"
    end
    it '1010は"千十"に変換されること' do
      suji = Suji.kanji_henkan(1010)
      expect(suji).to eq "千十"
    end
    it '1015は"千十五"に変換されること' do
      suji = Suji.kanji_henkan(1015)
      expect(suji).to eq "千十五"
    end
    it '1047は"千四十七"に変換されること' do
      suji = Suji.kanji_henkan(1047)
      expect(suji).to eq "千四十七"
    end
    it '1100は"千百"に変換されること' do
      suji = Suji.kanji_henkan(1100)
      expect(suji).to eq "千百"
    end
    it '1101は"千百一"変換されること' do
      suji = Suji.kanji_henkan(1101)
      expect(suji).to eq "千百一"
    end
    it '1110は"千百十"に変換されること' do
      suji = Suji.kanji_henkan(1110)
      expect(suji).to eq "千百十"
    end
    it '1120は"千百二十"に変換されること' do
      suji = Suji.kanji_henkan(1120)
      expect(suji).to eq "千百二十"
    end
    it '1121は"千百二十一"に変換されること' do
      suji = Suji.kanji_henkan(1121)
      expect(suji).to eq "千百二十一"
    end
    it '1200は"千二百"に変換されること' do
      suji = Suji.kanji_henkan(1200)
      expect(suji).to eq "千二百"
    end
  end

  context 'kanji_henkanは8桁までうまく動くこと' do
    it '10000は"一万"に変換されること' do
      suji = Suji.kanji_henkan(10000)
      expect(suji).to eq "一万"
    end
    it '20000は"二万"に変換されること' do
      suji = Suji.kanji_henkan(20000)
      expect(suji).to eq "二万"
    end
    it '10001は"一万一"に変換されること' do
      suji = Suji.kanji_henkan(10001)
      expect(suji).to eq "一万一"
    end
    it '35784は"三万五千七百八十四"に変換されること' do
      suji = Suji.kanji_henkan(35784)
      expect(suji).to eq "三万五千七百八十四"
    end
    it '735784は"七十三万五千七百八十四"に変換されること' do
      suji = Suji.kanji_henkan(735784)
      expect(suji).to eq "七十三万五千七百八十四"
    end
    it '9578642"九百五十七万八千六百四十二"に変換されること' do
      suji = Suji.kanji_henkan(9578642)
      expect(suji).to eq "九百五十七万八千六百四十二"
    end
    it '27825672"二千七百八十二万五千六百七十二"に変換されること' do
      suji = Suji.kanji_henkan(27825672)
      expect(suji).to eq "二千七百八十二万五千六百七十二"
    end
  end

end

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

end
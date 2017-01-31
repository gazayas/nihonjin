require 'spec_helper'

describe Nihonjin::Suji do

  let(:suji) { Nihonjin::Suji.new }

  describe '#to_i' do
    subject { suji.to_i(num) }
    let(:expected_result) { 10 }

    context '整数から整数' do
      let(:num) { 10 }
      it { is_expected.to eq expected_result}
    end

    context '文字列から整数' do
      let(:num ) { "10" }
      it { is_expected.to eq expected_result }
    end

    context '全角の数字から整数' do
      let(:num) { "１０" }
      it { is_expected.to eq expected_result }
    end

    context '漢字から整数' do
      let(:num) { '一〇' }
      it { is_expected.to eq expected_result }
    end

    context '大字から整数' do
      let(:num) { '壱零' }
      it { is_expected.to eq expected_result }
    end
  end

  describe '#type?' do
    subject { suji.type?(num) }

    context '整数の場合' do
      let(:num) { 10 }
      it { is_expected.to eq "半角" }
    end

    context '整数の文字列の場合' do
      let(:num) { "10" }
      it { is_expected.to eq "半角" }
    end

    context '全角の整数の場合' do
      let(:num) { "１０" }
      it { is_expected.to eq "全角" }
    end

    context '漢字の場合' do
      let(:num) { "一〇" }
      it { is_expected.to eq "漢字" }
    end

    context '大字の場合' do
      let(:num) { "壱零" }
      it { is_expected.to eq "大字" }
    end
  end

  describe '#zenkaku' do
    subject { suji.zenkaku(num) }

    context '半角の整数の場合' do
      let(:num) { 10 }
      it { is_expected.to eq "１０" }
    end

    context '漢字の場合' do
      let(:num) { "一〇" }
      it { is_expected.to eq "１０" }
    end
  end

  context '#kanji_henkan' do
    subject { suji.kanji_henkan(num) }

    describe '４桁以下の数字（区切りは４桁(#sen)までですから）' do

      # #juは裏で動いています
      context '１桁は１桁を返すこと' do
        let(:num) { 5 }
        it { is_expected.to eq "五" }
      end

      context '２桁は２桁を返すこと' do
        let(:num) { 10 }
        it { is_expected.to eq "十" }
      end

      context '２桁は３桁を返すこと' do
        let(:num) { 15 }
        it { is_expected.to eq "十五" }
      end

      context '２桁は３桁を返すこと' do
        let(:num) { 55 }
        it { is_expected.to eq "五十五" }
      end

      # #hyakuは裏で動いています
      context '３桁は１桁を返すこと' do
        let(:num) { 100 }
        it { is_expected.to eq "百" }
      end

      context '中に0がある場合、無視されること' do
        let(:num) { 505 }
        it { is_expected.to eq "五百五" }
      end

      context '３桁は５桁を返すこと' do
        let(:num) { 555 }
        it { is_expected.to eq "五百五十五" }
      end

      # #senは裏で動いています
      context '４桁は１桁を返すこと' do
        let(:num) { 1000 }
        it { is_expected.to eq "千" }
      end

      context '中に0がある場合、無視されること' do
        let(:num) { 5005 }
        it { is_expected.to eq "五千五" }
      end

      context '４桁は７桁を返すこと' do
        let(:num) { 5555 }
        it { is_expected.to eq "五千五百五十五" }
      end
    end

    describe '４桁以上の数字' do
      context '５桁は２桁を返すこと' do
        let(:num) { 1_0000 }
        it { is_expected.to eq "一万" }
      end

      context '中に0がある場合、無視されること' do
        let(:num) { 5_0005 }
        it { is_expected.to eq "五万五" }
      end

      context '５桁は９桁を返すこと' do
        let(:num) { 5_5555 }
        it { is_expected.to eq "五万五千五百五十五" }
      end

      context '一億以上の数字が適切に返されること' do
        let(:num) { 55_5555_5555 }
        it { is_expected.to eq "五十五億五千五百五十五万五千五百五十五"}
      end

      context '一兆以上の数字が適切に返されること' do
        let(:num) { 55_5555_5555_5555 }
        it { is_expected.to eq "五十五兆五千五百五十五億五千五百五十五万五千五百五十五"}
      end

      context '一京以上の数字が適切に返されること' do
        let(:num) { 55_5555_5555_5555_5555 }
        it { is_expected.to eq "五十五京五千五百五十五兆五千五百五十五億五千五百五十五万五千五百五十五" }
      end
    end
  end
  
end

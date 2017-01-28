require 'spec_helper'

describe Nihonjin::Moji do

  # shift_jis(str)やid_of(str)などのメソッドはspec_helperに入っています

  let(:moji) { Nihonjin::Moji.new }
  # よく使うやつだけをここに宣言した方がいい。
  # それ意外はテストの中でリテラルとして定義した方が分かりやすいと思う。
  let(:strings) {
    {
      hiragana_str: 'にんげん　の　ごじゅうねん　は　はかない　もの　だ。',
      katakana_str: 'ニンゲン　ノ　ゴジュウネン　ハ　ハカナイ　モノ　ダ。',
      hankaku_katakana_str: 'ﾆﾝｹﾞﾝ　ﾉ　ｺﾞｼﾞｭｳﾈﾝ　ﾊ　ﾊｶﾅｲ　ﾓﾉ　ﾀﾞ｡',
      romaji_str: 'ningen no gojuunen ha hakanai mono da.',
      mixed_str: 'ニンゲン　no　ごじゅうねん　ha　ハカナイ　もの　da.',
      upcase_str: 'NINGEN NO GOJUUNEN HA HAKANAI MONO DA.',
      hiragana_kuhaku_nashi_str: 'にんげんのごじゅうねんははかないものだ。',
      romaji_kuhaku_nashi_str: 'ningennogojuunenhahakanaimonoda.',

      x_str: 'chiisai tsu axtsuta yo! axtsuta!',
      romaji_small_tsu_str: 'chiisai tsu atta yo! atta!',
      hiragana_small_tsu_str: 'ちいさい　つ　あった　よ！　あった！',

      romaji_multiple_small_tsu_str: 'zetttttaini!',
      hiragana_multiple_small_tsu_str: 'ぜっっっったいに！',
    }
  }
  let(:options) { nil }
  let(:kuhaku_option) { nil }

  describe '#hiragana' do
    subject { moji.hiragana(str_to_change, options) }

    context 'ローマ字からの変換' do
      let(:str_to_change){ strings[:romaji_str] }
      it { is_expected.to eq strings[:hiragana_str] }
    end

    context 'カタカナからの変換' do
      let(:str_to_change){ strings[:katakana_str] }
      it { is_expected.to eq strings[:hiragana_str] }
    end

    context 'ミックスの文字列の変換' do
      let(:str_to_change){ strings[:mixed_str] }
      it { is_expected.to eq strings[:hiragana_str] }
    end

    context '大文字の文字列の変換' do
      let(:str_to_change){ strings[:upcase_str] }
      it { is_expected.to eq strings[:hiragana_str] }
    end

    context '小さい「っ」を入れたい場合' do
      let(:str_to_change){ strings[:romaji_small_tsu_str] }
      it { is_expected.to eq strings[:hiragana_small_tsu_str] }
    end

    context '複数の小さい「っ」を入れたい場合' do
      let(:str_to_change){ strings[:romaji_multiple_small_tsu_str] }
      it { is_expected.to eq strings[:hiragana_multiple_small_tsu_str] }
    end

    context '「x」によって次の文字が小さくなる文字列の変換' do
      let(:str_to_change){ strings[:x_str] }
      it { is_expected.to eq strings[:hiragana_small_tsu_str] }
    end

    context 'ミューテイトしない場合' do
      subject { id_of(moji.hiragana(str_to_change, options)) }
      let(:str_to_change){ strings[:romaji_str] }
      it { is_expected.not_to eq id_of(str_to_change) }
    end

    describe 'オプションを渡す場合' do
      context 'シンボルを渡す場合' do
        let(:str_to_change){ strings[:romaji_str] }
        let(:options){ :shift_jis }
        it { is_expected.to eq shift_jis(strings[:hiragana_str])}
      end

      context '文字列リテラルを渡す場合' do
        let(:str_to_change){ strings[:romaji_str] }
        let(:options) { '-s --mac' }
        it { is_expected.to eq shift_jis(strings[:hiragana_str]) }
      end
    end
  end

  describe '#hiragana!' do
    context 'ミューテイトすること' do
      subject { id_of(moji.hiragana!(str_to_change, options)) }
      let(:str_to_change){ strings[:romaji_str] }
      it { is_expected.to eq id_of(str_to_change) }
    end

    subject { moji.hiragana!(str_to_change, options) }

    context 'オプションを渡す場合' do
      let(:str_to_change){ strings[:romaji_str] }
      let(:options){ '-s --mac' }
      it { is_expected.to eq shift_jis(strings[:hiragana_str]) }
    end
  end



  describe '#katakana' do
    subject { moji.katakana(str_to_change, options) }

    context 'ローマ字からの変換' do
      let(:str_to_change){ strings[:romaji_str] }
      it { is_expected.to eq strings[:katakana_str] }
    end

    context 'ひらがなからの変換' do
      let(:str_to_change){ strings[:hiragana_str] }
      it { is_expected.to eq strings[:katakana_str] }
    end

    context 'ミックスの文字列の変換' do
      let(:str_to_change){ strings[:mixed_str] }
      it { is_expected.to eq strings[:katakana_str] }
    end
  end

  describe '#katakana!' do
    context 'ミューテイトすること' do
      subject { id_of(moji.katakana!(str_to_change, options)) }
      let(:str_to_change){ strings[:romaji_str] }
      it { is_expected.to eq id_of(str_to_change)}
    end

    subject { moji.katakana!(str_to_change, options) }

    # #katakana!でoptionsが二重してしまうから次のテストは大事です
    context 'オプションを渡す場合' do
      let(:str_to_change){ strings[:romaji_str] }
      let(:options) { '-s --mac' }
      it { is_expected.to eq shift_jis(strings[:katakana_str]) }
    end
  end



  describe '#hankaku_katakana' do
    subject { moji.hankaku_katakana(str_to_change, options) }

    context 'ローマ字からの変換' do
      let(:str_to_change){ strings[:romaji_str] }
      it { is_expected.to eq strings[:hankaku_katakana_str]}
    end

    context 'ひらがなからの変換' do
      let(:str_to_change){ strings[:hiragana_str] }
      it { is_expected.to eq strings[:hankaku_katakana_str]}
    end

    context 'オプションを渡す場合' do
      let(:str_to_change) { strings[:katakana_str] }
      let(:options) { '-s --mac' }
      it { is_expected.to eq shift_jis(strings[:hankaku_katakana_str])}
    end
  end

  describe '#hankaku_katakana!' do
    context 'ミューテイトすること' do
      subject { id_of(moji.hankaku_katakana!(str_to_change, options)) }
      let(:str_to_change){ strings[:romaji_str] }
      it { is_expected.to eq id_of(str_to_change)}
    end

    subject { moji.hankaku_katakana!(str_to_change, options) }

    context 'オプションを渡す場合' do
      let(:str_to_change){ strings[:romaji_str] }
      let(:options){ '-s --mac' }
      it { is_expected.to eq shift_jis(strings[:hankaku_katakana_str]) }
    end
  end



  describe '#romaji' do
    subject { moji.romaji(str_to_change, options) }

    context 'ひらがなからの変換' do
      let(:str_to_change){ strings[:hiragana_str] }
      it { is_expected.to eq strings[:romaji_str] }
    end

    context 'カタカナからの変換' do
      let(:str_to_change){ strings[:katakana_str] }
      it { is_expected.to eq strings[:romaji_str] }
    end

    context '半角カタカナからの変換' do
      let(:str_to_change){ strings[:hankaku_katakana_str] }
      it { is_expected.to eq strings[:romaji_str] }
    end

    context '小さな「つ」が入っている文字列の場合' do
      let(:str_to_change){ strings[:hiragana_small_tsu_str] }
      it { is_expected.to eq strings[:romaji_small_tsu_str] }
    end

    context '複数の小さな「つ」が入っている文字列の場合' do
      let(:str_to_change){ strings[:hiragana_multiple_small_tsu_str] }
      it { is_expected.to eq strings[:romaji_multiple_small_tsu_str] }
    end
  end

  describe '#romaji!' do
    context 'ミューテイトすること' do
      subject { id_of(moji.romaji!(str_to_change, options)) }
      let(:str_to_change){ strings[:hiragana_str] }
      it { is_expected.to eq id_of(str_to_change)}
    end

    subject { moji.romaji!(str_to_change, options) }
    context 'オプションを渡す場合' do
      let(:str_to_change){ strings[:hiragana_str] }
      let(:options){ '-s --mac' }
      it { is_expected.to eq shift_jis(strings[:romaji_str]) }
    end
  end



  describe '#kana_invert' do
    subject { moji.kana_invert(str_to_change, options) }

    context 'ミックスの文字列の変換' do
      let(:str_to_change){ 'あイうエお' }
      it { is_expected.to eq 'アいウえオ' }
    end
  end

  describe '#kana_invert!' do
    context 'ミューテイトすること' do
      subject { id_of(moji.kana_invert!(str_to_change, options)) }
      let(:str_to_change){ strings[:hiragana_str] }
      it { is_expected.to eq id_of(str_to_change) }
    end

    subject { moji.kana_invert!(str_to_change, options) }

    context 'オプションを渡す場合' do
      let(:str_to_change){ strings[:hiragana_str] }
      let(:options){ '-s --mac' }
      it { is_expected.to eq shift_jis(str_to_change) }
    end
  end



  describe '#kiru' do
    subject { moji.kiru(str_to_change) }

    context '全角の空白をうまく切り落とすこと' do
      let(:str_to_change){ strings[:hiragana_str] }
      it { is_expected.to eq strings[:hiragana_kuhaku_nashi_str] }
    end

    context '半角の空白をうまくキリオツスこと' do
      let(:str_to_change){ strings[:romaji_str] }
      it { is_expected.to eq strings[:romaji_kuhaku_nashi_str] }
    end
  end

  describe '#kuri!' do
    context 'ミューテイトすること' do
      subject { id_of(moji.kiru!(str_to_change)) }
      let(:str_to_change){ strings[:hiragana_str] }
      it { is_expected.to eq id_of(str_to_change) }
    end
  end



  describe '#hashigiri' do
    subject { moji.hashigiri(str_to_change) }

    context '端にある全角の空白を切り落とすこと' do
      let(:str_to_change) { '　全角の空白　' }
      it { is_expected.to eq '全角の空白' }
    end

    context '端にある半角の空白を切り落とすこと' do
      let(:str_to_change) { ' 半角の空白 ' }
      it { is_expected.to eq '半角の空白' }
    end
  end

  describe '#hashigiri!' do
    context 'ミューテイトすること' do
      subject { id_of(moji.hashigiri!(str_to_change)) }
      let(:str_to_change) { '　全角の空白　' }
      it { is_expected.to eq id_of(str_to_change) }
    end
  end


  describe '#kuhaku' do
    subject { moji.kuhaku(str_to_change, kuhaku_option) }

    context '半角の空白を全角の空白にすること' do
      let(:str_to_change)  { '空白　を　変える' }
      it { is_expected.to eq '空白 を 変える'}
    end

    context 'オプションを渡す場合' do
      let(:kuhaku_option){ :zenkaku }
      let(:str_to_change)  { '空白 を 変える' }
      it { is_expected.to eq '空白　を　変える'}
    end
  end

  describe '#kuhaku!' do
    context 'ミューテイトすること' do
      subject { id_of(moji.kuhaku!(str_to_change, kuhaku_option)) }
      let(:str_to_change){ strings[:hiragana_str] }
      it { is_expected.to eq id_of(str_to_change) }
    end

    subject { moji.kuhaku!(str_to_change, kuhaku_option) }

    context 'オプションを渡す場合' do
      let(:kuhaku_option){ :zenkaku }
      let(:str_to_change)  { '空白　を　変える' }
      it { is_expected.to eq '空白 を 変える'}
    end
  end



  describe '#kuhaku_invert' do
    subject { moji.kuhaku_invert(str_to_change) }
    context '空白を変換すること' do
      let(:str_to_change){   '文字列　です ' } # 最初の空白は全角で、最後の空白は半角です
      it { is_expected.to eq '文字列 です　' }
    end
  end

  describe '#kuhaku_invert!' do
    context 'ミューテイトすること' do
      subject { id_of(moji.kuhaku_invert!(str_to_change)) }
      let(:str_to_change){ strings[:hiragana_str] }
      it { is_expected.to eq id_of(str_to_change) }
    end
  end

end

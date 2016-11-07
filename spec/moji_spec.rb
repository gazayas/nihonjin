require 'spec_helper'

describe Moji do

  let(:zenkaku_str) { '全角　ばっかり　です　ね' }
  let(:hankaku_str) { '半角 ばっかり です ね' }
  let(:hiragana_str) { 'にんげん　の　ごじゅうねん　は　はかない　もの　だ。' }
  let(:katakana_str) { 'ニンゲン　ノ　ゴジュウネン　ハ　ハカナイ　モノ　ダ。' }
  let(:romaji_str) { 'ningen no gojuunen ha hakanai mono da.' }
  let(:kuhaku_invert_str) { '　左は全角の空白で、右は半角 ' }
  let(:mixed_str) { 'ニンゲン　no　ごじゅうねん　ha　ハカナイ　もの　da.' }
  # shift_jis(str)などのメソッドはspec_helperに入っています

  describe '#kuhaku' do
    context '半角に変換する場合' do
      it 'うまく変換される' do
        str = Moji.kuhaku(zenkaku_str)
        str = str.split(/\s/)
        expect(str.length).to eq(4)
      end
      it '適切なエンコーディングを返すこと' do
        shift_str = shift_jis(zenkaku_str)
        new_str = Moji.kuhaku(shift_str)
        expect(new_str.encoding).to eq(shift_str.encoding)
      end
    end

    context '全角に変換する場合' do
      it 'うまく変換される' do
        str = Moji.kuhaku('半角 ばっかり です ね', :zenkaku)
        str = str.split(/　/)
        expect(str.length).to eq(4)
      end
      it '適切なエンコーディングを返すこと' do
        euc_jp_str = euc_jp(hankaku_str)
        new_str = Moji.kuhaku(euc_jp_str, :zenkaku)
        expect(new_str.encoding).to eq(euc_jp_str.encoding)
      end
    end
  end

  describe '#kuhaku_invert' do
     context '全角も半角が両方入ってる時' do
       it '両方がうまく入れ替えられること' do
         new_str = Moji.kuhaku_invert(kuhaku_invert_str)
         expect(new_str).to match(/(^\s)(.+)(　$)/)
       end
       it '適切なエンコーディングを返すこと' do
         shift_jis_str = shift_jis(kuhaku_invert_str)
         new_str = Moji.kuhaku_invert(shift_jis_str)
         expect(new_str.encoding).to eq(shift_jis_str.encoding)
       end
     end

     context '１つの空白の種類だけの場合' do
       it '全角だけが入ってる文字列が変換されること' do
         new_str = Moji.kuhaku_invert(zenkaku_str)
         new_str = new_str.split(/\s/)
         expect(new_str.length).to eq(4)
       end
       it '半角だけが入ってる文字列が変換されること' do
         new_str = Moji.kuhaku_invert(hankaku_str)
         new_str = new_str.split("　")
         expect(new_str.length).to eq(4)
       end
     end
  end

  describe '#hiragana' do
    context 'ローマ字の場合' do
      it 'うまく変換されること' do
        new_str = Moji.hiragana(romaji_str)
        expect(new_str).to eq(hiragana_str)
      end
    end

    context 'カタカナの場合' do
      it 'うまく変換されること' do
        new_str = Moji.hiragana(katakana_str)
        expect(new_str).to eq(hiragana_str)
      end
    end

    context 'ミックスの場合' do
      it 'うまく変換されること' do
        new_str = Moji.hiragana(mixed_str)
        expect(new_str).to eq(hiragana_str)
      end
    end

    context 'ミューテイトしない場合' do
      it '変数はミューテイトしないこと' do
        original_id = katakana_str.__id__
        new_str = Moji.hiragana(katakana_str)
        expect(new_str.__id__).not_to eq original_id
      end
    end

    context 'オプションを渡す場合' do
      it '別のリテラルとしてうまく定義されること' do
        new_str = Moji.hiragana(katakana_str, '-s', '--mac')
        shift_jis_str = shift_jis(katakana_str)
        expect(new_str.encoding).to eq(shift_jis_str.encoding)
      end
      it '１つのリテラルとしてうまく定義されること' do
        new_str = Moji.hiragana(katakana_str, '-s --mac')
        shift_jis_str = shift_jis(katakana_str)
        expect(new_str.encoding).to eq(shift_jis_str.encoding)
      end
    end
  end

  describe '#hiragana!' do
    context 'ミューテイトする場合' do
      it 'うまくミューテイトされること' do
        original_id = katakana_str.__id__
        Moji.hiragana!(katakana_str)
        expect(katakana_str.__id__).to eq original_id
      end
    end

    # #hiragana!でoptionsが二重してしまうから次のテストは大事です
    context 'オプションを渡す場合' do
      it '別のリテラルとしてうまく定義されること' do
        new_str = Moji.hiragana!(katakana_str, '-s', '--mac')
        shift_jis_str = shift_jis(katakana_str)
        expect(new_str.encoding).to eq(shift_jis_str.encoding)
      end
      it '１つのリテラルとしてうまく定義されること' do
        new_str = Moji.hiragana!(katakana_str, '-s --mac')
        shift_jis_str = shift_jis(katakana_str)
        expect(new_str.encoding).to eq(shift_jis_str.encoding)
      end
    end
  end

  describe '#katakana' do
  end

  describe '#katakana!' do
  end

  describe '#hankaku_katakana' do
  end

  describe '#hankaku_katakana!' do
  end

  describe '#romaji' do
  end

  describe '#romaji!' do
  end

  describe '#kana_invert' do
  end

  describe '#kana_invert!' do
  end

  describe '#kiru' do
  end

  describe '#kiru!' do
  end

  describe '#hashigiri' do
  end

  describe '#hashigiri!' do
  end

end

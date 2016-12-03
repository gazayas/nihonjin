require 'spec_helper'

describe Nihonjin::Moji do

  let(:moji) { Nihonjin::Moji.new }
  let(:hiragana_str) { 'にんげん　の　ごじゅうねん　は　はかない　もの　だ。' }

  # shift_jis(str)などのメソッドはspec_helperに入っています

  describe '#kuhaku' do

    let(:zenkaku_str) { '全角　ばっかり　です　ね' }
    let(:hankaku_str) { '半角 ばっかり です ね' }

    context '半角に変換する場合' do
      it 'うまく変換される' do
        str = moji.kuhaku(zenkaku_str)
        str = str.split(/\s/)
        expect(str.length).to eq(4)
      end
      it '適切なエンコーディングを返すこと' do
        shift_str = shift_jis(zenkaku_str)
        new_str = moji.kuhaku(shift_str)
        expect(new_str.encoding).to eq(shift_str.encoding)
      end
    end

    context '全角に変換する場合' do
      it 'うまく変換される' do
        str = moji.kuhaku('半角 ばっかり です ね', :zenkaku)
        str = str.split(/　/)
        expect(str.length).to eq(4)
      end
      it '適切なエンコーディングを返すこと' do
        euc_jp_str = euc_jp(hankaku_str)
        new_str = moji.kuhaku(euc_jp_str, :zenkaku)
        expect(new_str.encoding).to eq(euc_jp_str.encoding)
      end
    end
  end


  describe '#kuhaku_invert' do

    let(:zenkaku_str) { '全角　ばっかり　です　ね' }
    let(:hankaku_str) { '半角 ばっかり です ね' }
    let(:kuhaku_invert_str) { '　左は全角の空白で、右は半角 ' }

     context '全角も半角が両方入ってる時' do
       it '両方がうまく入れ替えられること' do
         new_str = moji.kuhaku_invert(kuhaku_invert_str)
         expect(new_str).to match(/(^\s)(.+)(　$)/)
       end
       it '適切なエンコーディングを返すこと' do
         shift_jis_str = shift_jis(kuhaku_invert_str)
         new_str = moji.kuhaku_invert(shift_jis_str)
         expect(new_str.encoding).to eq(shift_jis_str.encoding)
       end
     end

     context '１つの空白の種類だけの場合' do
       it '全角だけが入ってる文字列が変換されること' do
         new_str = moji.kuhaku_invert(zenkaku_str)
         new_str = new_str.split(/\s/)
         expect(new_str.length).to eq(4)
       end
       it '半角だけが入ってる文字列が変換されること' do
         new_str = moji.kuhaku_invert(hankaku_str)
         new_str = new_str.split("　")
         expect(new_str.length).to eq(4)
       end
     end
  end


  describe '#hiragana' do

    let(:katakana_str) { 'ニンゲン　ノ　ゴジュウネン　ハ　ハカナイ　モノ　ダ。' }
    let(:romaji_str) { 'ningen no gojuunen ha hakanai mono da.' }
    let(:mixed_str) { 'ニンゲン　no　ごじゅうねん　ha　ハカナイ　もの　da.' }
    let(:upcase_str) { 'NINGEN NO GOJUUNEN HA HAKANAI MONO DA.' }
    let(:small_tsu_str) { 'chiisai tsu atta yo! atta!' }

    context 'ローマ字の場合' do
      it 'うまく変換されること' do
        new_str = moji.hiragana(romaji_str)
        expect(new_str).to eq(hiragana_str)
      end
    end

    # このように「ちょ」みたいな変数がうまく変換されるテストを書いた方がいいかもしれない
    context 'まっちょ' do
      it '「まっちょ」に変換されること' do
        new_str = moji.hiragana("maccho")
        expect(new_str).to eq("まっちょ")
      end
    end

    context 'カタカナの場合' do
      it 'うまく変換されること' do
        new_str = moji.hiragana(katakana_str)
        expect(new_str).to eq(hiragana_str)
      end
    end

    context 'ミックスの場合' do
      it 'うまく変換されること' do
        new_str = moji.hiragana(mixed_str)
        expect(new_str).to eq(hiragana_str)
      end
    end

    context '大文字の場合' do
      it 'うまく変換されること' do
        new_str = moji.hiragana(upcase_str)
        expect(new_str).to eq(hiragana_str)
      end
    end

    context '小さい「っ」が入るはず場合' do
      it 'うまく変換される' do
        new_str = moji.hiragana(small_tsu_str)
        expect(new_str).to eq("ちいさい　つ　あった　よ！　あった！")
      end
    end

    context 'ミューテイトしない場合' do
      it '変数はミューテイトしないこと' do
        original_id = katakana_str.__id__
        new_str = moji.hiragana(katakana_str)
        expect(new_str.__id__).not_to eq original_id
      end
    end

    describe 'オプションを渡す場合' do
      context 'シンボルとしてオプションを渡す場合' do
        it ':utf_8（デフォルト）の場合' do
          new_str = moji.hiragana(katakana_str, :utf_8)
          utf8_str = utf_8(katakana_str)
          expect(new_str.encoding).to eq(katakana_str.encoding)
        end
        it ':shift_jisの場合' do
          new_str = moji.hiragana(katakana_str, :shift_jis)
          shift_jis_str = shift_jis(katakana_str)
          expect(new_str.encoding).to eq(shift_jis_str.encoding)
        end
      end

      context '文字列としてオプションを渡す場合' do
        it '別のリテラルとしてうまく定義されること' do
          new_str = moji.hiragana(katakana_str, '-s', '--mac')
          shift_jis_str = shift_jis(katakana_str)
          expect(new_str.encoding).to eq(shift_jis_str.encoding)
        end
        it '１つのリテラルとしてうまく定義されること' do
          new_str = moji.hiragana(katakana_str, '-s --mac')
          shift_jis_str = shift_jis(katakana_str)
          expect(new_str.encoding).to eq(shift_jis_str.encoding)
        end
      end
    end
  end


  describe '#hiragana!' do

    let(:katakana_str) { 'ニンゲン　ノ　ゴジュウネン　ハ　ハカナイ　モノ　ダ。' }

    context 'ミューテイトする場合' do
      it 'うまくミューテイトされること' do
        original_id = katakana_str.__id__
        moji.hiragana!(katakana_str)
        expect(katakana_str.__id__).to eq original_id
      end
    end

    # #hiragana!でoptionsが二重してしまうから次のテストは大事です
    context 'オプションを渡す場合' do
      it '別のリテラルとしてうまく定義されること' do
        new_str = moji.hiragana!(katakana_str, '-s', '--mac')
        shift_jis_str = shift_jis(katakana_str)
        expect(new_str.encoding).to eq(shift_jis_str.encoding)
      end
      it '１つのリテラルとしてうまく定義されること' do
        new_str = moji.hiragana!(katakana_str, '-s --mac')
        shift_jis_str = shift_jis(katakana_str)
        expect(new_str.encoding).to eq(shift_jis_str.encoding)
      end
    end

  end


  describe '#katakana' do

    let(:katakana_str) { 'ニンゲン　ノ　ゴジュウネン　ハ　ハカナイ　モノ　ダ。' }
    let(:romaji_str) { 'ningen no gojuunen ha hakanai mono da.' }
    let(:hiragana_str) { 'にんげん　の　ごじゅうねん　は　はかない　もの　だ。' }
    let(:mixed_str) { 'ニンゲン　no　ごじゅうねん　ha　ハカナイ　もの　da.' }

    context '文字をカタカナに変換する' do
      it 'ローマ字の場合' do
        new_str = moji.katakana(romaji_str)
        expect(new_str).to eq (katakana_str)
      end

      it 'ひらがなの場合' do
        new_str = moji.katakana(romaji_str)
        expect(new_str).to eq (katakana_str)
      end

      it 'ミックスの場合' do
        new_str = moji.katakana(mixed_str)
        expect(new_str).to eq (katakana_str)
      end
    end

  end


  describe '#katakana!' do

    let(:romaji_str) { 'ningen no gojuunen ha hakanai mono da.' }
    let(:katakana_str) { 'ニンゲン　ノ　ゴジュウネン　ハ　ハカナイ　モノ　ダ。' }

    context 'ミューテイトする場合' do
      it 'うまくミューテイトされること' do
        original_id = romaji_str.__id__
        moji.katakana!(romaji_str)
        expect(romaji_str.__id__).to eq original_id
      end
    end

    # #katakana!でoptionsが二重（三重？）してしまうから次のテストは大事です
    context 'オプションを渡す場合' do
      it '別のリテラルとしてうまく定義されること' do
        new_str = moji.katakana!(romaji_str, '-s', '--mac')
        shift_jis_str = shift_jis(romaji_str)
        expect(new_str.encoding).to eq(shift_jis_str.encoding)
      end
      it '１つのリテラルとしてうまく定義されること' do
        new_str = moji.katakana!(romaji_str, '-s --mac')
        shift_jis_str = shift_jis(romaji_str)
        expect(new_str.encoding).to eq(romaji_str.encoding)
      end
    end

  end


  describe '#hankaku_katakana' do
  end


  describe '#hankaku_katakana!' do
  end


  describe '#romaji' do

    let(:hiragana_str) { 'にんげん　の　ごじゅうねん　は　はかない　もの　だ。' }
    let(:romaji_str) { 'ningen no gojuunen ha hakanai mono da.' }

    context 'ローマ字に変換されること' do
      it 'うまく変換されること' do
        new_str = moji.romaji(hiragana_str)
        expect(new_str).to eq(romaji_str)
      end
    end

  end


  describe '#romaji!' do
  end


  describe '#kana_invert' do

    let(:hiragana_str) { 'にんげん　の　ごじゅうねん　は　はかない　もの　だ。' }
    let(:katakana_str) { 'ニンゲン　ノ　ゴジュウネン　ハ　ハカナイ　モノ　ダ。' }
    let(:mixed_str) { 'ニンゲン　no　ごじゅうねん　ha　ハカナイ　もの　da.' }
    let(:inverted_mixed_str) { 'にんげん　no　ゴジュウネン　ha　はかない　モノ　da.'}

    context 'かなを逆にする' do
      it 'カタカナに変換される' do
        new_str = moji.kana_invert(hiragana_str)
        expect(new_str).to eq(katakana_str)
      end

      it 'ひらがなに変換される' do
        new_str = moji.kana_invert(katakana_str)
        expect(new_str).to eq(hiragana_str)
      end

      it '適切な文字だけが変換される' do
        new_str = moji.kana_invert(mixed_str)
        expect(new_str).to eq(inverted_mixed_str)
      end
    end

  end


  describe '#kana_invert!' do

    let(:hiragana_str) { 'にんげん　の　ごじゅうねん　は　はかない　もの　だ。' }
    let(:katakana_str) { 'ニンゲン　ノ　ゴジュウネン　ハ　ハカナイ　モノ　ダ。' }

    context 'ミューテイトする場合' do
      it 'うまくミューテイトされること' do
        original_id = hiragana_str.__id__
        moji.kana_invert!(hiragana_str)
        expect(hiragana_str.__id__).to eq original_id
      end
    end

    context 'オプションを渡す場合' do
      it '別のリテラルとしてうまく定義されること' do
        new_str = moji.kana_invert!(hiragana_str, '-s', '--mac')
        shift_jis_str = shift_jis(hiragana_str)
        expect(new_str.encoding).to eq(shift_jis_str.encoding)
      end
      it '１つのリテラルとしてうまく定義されること' do
        new_str = moji.kana_invert!(hiragana_str, '-s --mac')
        shift_jis_str = shift_jis(hiragana_str)
        expect(new_str.encoding).to eq(hiragana_str.encoding)
      end
    end

  end


  describe '#kiru' do

    let(:hankaku_kiru_str) { ' この 空白 は 半角だけ ' }
    let(:zenkaku_kiru_str) { '　この　空白　は　全角　だけ　'}
    let(:mixed_kiru_str) { ' 最初 は 半角 。　後　は　全角　' }

    context '半角の空白だけ' do
      it '空白はなくなること' do
        new_str = moji.kiru(hankaku_kiru_str)
        expect(new_str).to_not match(/\s/)
      end
    end

    context '全角の空白だけ' do
      it '空白はなくなること' do
        new_str = moji.kiru(zenkaku_kiru_str)
        expect(new_str).to_not match(/　/)
      end
    end

    context '全角の空白も半角の空白もなくなる' do
      it '空白はなくなること' do
        new_str = moji.kiru(mixed_kiru_str)
        expect(new_str).to_not match(/　/)
        expect(new_str).to_not match(/\s/)
      end
    end
  end


  describe '#kiru!' do

    let(:zenkaku_kiru_str) { '　この　空白　は　全角　だけ　'}
    
    context 'ミューテイトする場合' do
      it 'うまくミューテイトされること' do
        original_id = zenkaku_kiru_str.__id__
        moji.kiru!(zenkaku_kiru_str)
        expect(zenkaku_kiru_str.__id__).to eq original_id
      end
    end
  end


  describe '#hashigiri' do

    let(:hankaku_hashigiri_str) { ' 半角の空白 ' }
    let(:zenkaku_hashigiri_str) { '　全角の空白　' }
    let(:kuhaku_invert_str) { '　左は全角の空白で、右は半角 ' }


    context '半角だけの場合' do
      it '端が切られること' do
        new_str = moji.hashigiri(hankaku_hashigiri_str)
        expect(new_str).to_not match(/^\s\s$/)
      end
    end

    context '全角だけの場合' do
      it '端が切られること' do
        new_str = moji.hashigiri(zenkaku_hashigiri_str)
        expect(new_str).to_not match(/^　　$/)
      end
    end

    context 'ミックスの場合' do
      it '端が切られること' do
        new_str = moji.hashigiri(kuhaku_invert_str)
        expect(new_str).to_not match(/^　\s$/)
      end
    end
  end


  describe '#hashigiri!' do

    let(:hankaku_hashigiri_str) { ' 半角の空白 ' }
    let(:zenkaku_hashigiri_str) { '　全角の空白　' }
    let(:kuhaku_invert_str) { '　左は全角の空白で、右は半角 ' }

    context '半角だけの場合' do
      it '端が切られること' do
        new_str = moji.hashigiri(hankaku_hashigiri_str)
        expect(new_str).to_not match(/^\s\s$/)
      end
    end

    context '全角だけの場合' do
      it '端が切られること' do
        new_str = moji.hashigiri(zenkaku_hashigiri_str)
        expect(new_str).to_not match(/^　　$/)
      end
    end

    context 'ミックスの場合' do
      it '端が切られること' do
        new_str = moji.hashigiri(kuhaku_invert_str)
        expect(new_str).to_not match(/^　\s$/)
      end
    end

    context 'ミューテイトする場合' do
      it 'うまくミューテイトされること' do
        original_id = zenkaku_hashigiri_str.__id__
        moji.hashigiri!(zenkaku_hashigiri_str)
        expect(zenkaku_hashigiri_str.__id__).to eq original_id
      end
    end
  end

end

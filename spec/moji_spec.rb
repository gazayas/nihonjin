require 'spec_helper'

describe Moji do

  let(:zenkaku_str) { '全角　ばっかり　です　ね' }
  let(:hankaku_str) { '半角 ばっかり です ね' }
  let(:hiragana) { 'にんげん　の　ごじゅうねん　は　はかない　もの　だ。' }
  let(:romaji) { 'ningen no gojuunen ha hakanai mono da' }
  let(:kuhaku_invert_str) { '　左は全角の空白で、右は半角 ' }
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


=begin

  describe '#hiragana' do
    let(:quote) { "にんげん　の　ごじゅうねん　は　はかない　もの　だ" }
    context 'ひらがなに変換されること' do
      it 'ローマ字から' do
        str = Moji.hiragana('ningen no gojuunen ha hakanai mono da')
        expect(str).to eq quote
      end

      it 'カタカナから' do
        str = Moji.hiragana('ニンゲン　ノ　ゴジュウネン　ハ　ハカナイ　モノ　ダ')
        expect(str).to eq quote
      end

      it 'ミックス' do
        str = Moji.hiragana('ニンゲン　no　ごじゅうねん　ha　ハカナイ　もの　da')
        expect(str).to eq quote
      end

      it '変数はミューテイトしないこと' do
        original_id = quote.__id__
        str = Moji.hiragana(quote)
        expect(str.__id__).not_to eq original_id
      end

      it '複数のオプションが上手く定義されること' do
        str = Moji.hiragana('hiragana ni　', '-w', '-Z2')
        expect(str).to eq 'ひらがな　に　　' # このテストの出力はあんまり好きじゃないから変えることにしたい
      end

      it '１つのリテラルにまとまったオプションが上手く定義されること' do
        str = Moji.hiragana('mojiretsu　', '-w -Z2') # １つの全角のスペースが２つの半角のスペースに
        expect(str).to eq 'もじれつ　　' # #hiraganaの中で#kuhakuが呼ばれるので、２つの半角のスペースは２つの全角のスペースになる
        # このテストはややこしすぎるww変えた方がいい
      end
    end
  end

  describe '#hiragana!' do
    let(:quote) { "にんげん　の　ごじゅうねん　は　はかない　もの　だ" }
    context 'ミュータブル性をテストすること' do
      it 'ミューテイトすること' do
        original_id = quote.__id__
        Moji.hiragana!(quote)
        expect(quote.__id__).to eq original_id
      end
    end
  end

=end
end

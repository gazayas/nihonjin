require 'spec_helper'

# 「は」の周りに空白があれば、romajiの場合は「wa」になる。それ意外には「ha」になる。

describe Moji do
  describe '#kuhaku' do
    let (:str) { 'にんげん　の　ごじゅうねん　は　はかない　もの　だ。' }
    context '空白はうまく変換されるかどうか確認' do
      it '普通の空白に変換する' do
        new_str = Moji.kuhaku(str)
        expect(new_str).not_to match /　/ # これは全角の空白
      end
      let(:str) { 'ningen no gojyunen wa hakanai mono da.' }
      it 'オプションを渡して普通の空白は全角に変換される' do
        new_str = Moji.kuhaku(str, :zenkaku)
        expect(new_str).not_to match /\s/
      end
    end
  end

  describe '#kuhaku_invert' do
      let(:str) { '　左は全角の空白で、右は半角 ' }
      context '空白は逆になること' do
        it '変換される' do
          new_str = Moji.kuhaku_invert(str)
          expect(new_str).to match /(^　)(.+)(\s$)/ # (.+)を変えるかな
        end
      end
  end

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

  describe '#kana_invert' do
  end

end

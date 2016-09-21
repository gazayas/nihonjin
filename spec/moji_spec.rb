require 'spec_helper'

# 「は」の周りに空白があれば、romajiの場合は「wa」になる。それ意外には「ha」になる。

describe Moji do
  describe '#kuhaku(str)' do
    let (:str) { 'にんげん　の　ごじゅうねん　は　はかない　もの　だ。' }
    context '空白がうまく変換されるかどうか確認' do
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
end

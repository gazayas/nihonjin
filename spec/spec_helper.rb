$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'nihonjin'

# 文字コードのヘルバー
def utf_8(str)
  str = str.encode('UTF-8')
end

def shift_jis(str)
  str = str.encode('SHIFT_JIS')
end

def iso_2022_jp(str)
  str = str.encode("ISO-2022-JP")
end

def euc_jp(str)
  str = str.encode("EUC-JP")
end

# idを取得するためのメソッド
def id_of(str)
  str.__id__
end

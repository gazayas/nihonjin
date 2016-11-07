$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'nihonjin'
require 'moji'
require 'suji'

def shift_jis(str)
  str = str.encode('SHIFT_JIS')
end

def utf_8(str)
  str = str.encode('UTF-8')
end

def iso_2022_jp(str)
  str = str.encode("ISO-2022-JP")
end

def euc_jp(str)
  str = str.encode("EUC-JP")
end

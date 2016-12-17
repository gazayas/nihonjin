module Nihonjin

  EncodingTypes = {
    iso_2022_jp: '-j',
    shift_jis: '-s',
    euc: '-e',
    utf_8: '-w',
    UTF_16BE: '-w16',
    UTF_32BE: '-w32'
  }

  InputCode = {
    iso_2022_jp: '-J',
    shift_jis: '-S',
    euc: '-E',
    utf_8: '-W',
    UTF_16BE: '-W16',
    UTF_32BE: '-W32'
  }

  NewLineMode = {
    unix: '-Lu',
    windows: '-Lw',
    mac: '-Lm'
  }

  Systems = {
    unix: '--unix',
    mac: '--mac',
    msdos: '--msdos',
    windows: '--windows'
  }

end

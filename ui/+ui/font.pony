use "collections"
use "linal"


class Font
  var fontAtlas:FontAtlas
  var glyphData:Map[U8,GlyphData]
  
  new empty() =>
    fontAtlas = FontAtlas.empty()
    glyphData = Map[U8,GlyphData]()
  
  new create(fontJson:String) =>
    fontAtlas = FontAtlas.empty()
    glyphData = Map[U8,GlyphData](512)
    try
      fontAtlas = FontAtlas.fromString(fontJson)?
      for glyph in fontAtlas.glyph_data.values() do
        try
          glyphData(glyph.charcode(0)?) = glyph
        end
      end
    end

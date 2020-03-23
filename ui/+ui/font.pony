use "collections"
use "linal"
use "utility"

class Font
  var name:String
  var fontAtlas:FontAtlas
  var glyphData:Map[U8,GlyphData]
  
  new empty() =>
    name = "empty"
    fontAtlas = FontAtlas.empty()
    glyphData = Map[U8,GlyphData]()
  
  new create(fontJson:String) =>
    name = "empty"
    fontAtlas = FontAtlas.empty()
    glyphData = Map[U8,GlyphData](512)
    try
      fontAtlas = FontAtlas.fromString(fontJson)?
      name = fontAtlas.name
      Log.println("font name: %s", name)
      for glyph in fontAtlas.glyph_data.values() do
        try
          glyphData(glyph.charcode(0)?) = glyph
        end
      end
    end

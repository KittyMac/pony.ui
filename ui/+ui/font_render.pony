use "collections"
use "linal"
use "stringext"

type FontWrapType is U32
primitive FontWrap
  fun character():U32 => 0
  fun word():U32 => 1

type AlignmentType is U32
primitive Alignment
  fun left():U32 => 0
  fun center():U32 => 1
  fun right():U32 => 2

type VerticalAlignmentType is U32
primitive VerticalAlignment
  fun top():U32 => 0
  fun middle():U32 => 1
  fun bottom():U32 => 2


struct GlyphRenderData
  var bx:F32 = 0
  var by:F32 = 0
  var bw:F32 = 0
  var bh:F32 = 0
  var tx:F32 = 0
  var ty:F32 = 0
  var tw:F32 = 0
  var th:F32 = 0
  
  new zero() =>
    None
  
  new create(bx':F32, by':F32, bw':F32, bh':F32, tx':F32, ty':F32, tw':F32, th':F32) =>
    bx = bx'
    by = by'
    bw = bw'
    bh = bh'
    tx = tx'
    ty = ty'
    tw = tw'
    th = th'


class FontRender
  var font:Font
  var fontSize:F32 = 18
  var fontColor:RGBA = RGBA.black()
  var fontWrap:FontWrapType = FontWrap.word()
  var fontAlignment:AlignmentType = Alignment.left()
  var fontVerticalAlignment:VerticalAlignmentType = VerticalAlignment.middle()

  var bufferedGeometry:BufferedGeometry = BufferedGeometry
  
  var needs_rendered:Bool = false
  
  var glyphRenderData:Array[GlyphRenderData] = Array[GlyphRenderData]
  
  new empty() =>
    font = Font.empty()
  
  new create(font':Font, fontSize':F32, fontColor':RGBA) =>
    font = font'
    fontSize = fontSize'
    fontColor = fontColor'
  
  fun calcHash(bounds:R4):USize =>
    ((R4fun.x_min(bounds) + 0) + (R4fun.y_min(bounds) * 14639) + (R4fun.width(bounds) * 27143) + (R4fun.height(bounds) * 46811)).abs().usize()
  
  
  
  
  fun ref measureNextTextLine(text:String, start_index:USize, start_pen:V2, bounds:R4):(F32,USize) =>
    var i:USize = start_index
    var pen_x:F32 = start_pen._1
    var pen_y:F32 = start_pen._2
    
    let fontAtlas = font.fontAtlas
    let glyphData = font.glyphData
    var glyph = GlyphData.empty()
    
    var start_of_word_index:USize = start_index
    var end_of_word_pen_x:F32 = pen_x
    
    let bounds_xmax = R4fun.x_max(bounds)
    //let bounds_ymax = R4fun.y_max(bounds)
    
    let space_advance = fontAtlas.space_advance.f32() * fontSize
    var localWrap = FontWrap.character()
        
    try
      
      while i < text.size() do
        let c = text(i)?
        i = i + 1
        
        if c == '\n' then
          break
        end
        if c == ' ' then
          end_of_word_pen_x = pen_x
          pen_x = pen_x + space_advance
          localWrap = fontWrap
          start_of_word_index = i
          glyphRenderData.push(GlyphRenderData.zero())
          continue
        end
        if c == '\t' then
          pen_x = pen_x + (space_advance * 2)
          localWrap = fontWrap
          start_of_word_index = i
          glyphRenderData.push(GlyphRenderData.zero())
          continue
        end
        
        glyph = try 
          glyphData(c)?
        else
          start_of_word_index = i
          continue
        end
        
        
        let g_width = glyph.bbox_width.f32() * fontSize
        let g_height = glyph.bbox_height.f32() * fontSize
        let g_bearing_x = glyph.bearing_x.f32() * fontSize
        let g_bearing_y = glyph.bearing_y.f32() * fontSize
        let g_advance_x = glyph.advance_x.f32() * fontSize
      
        let s0 = glyph.s0.f32()
        let s1 = glyph.s1.f32()
        let t0 = glyph.t0.f32()
        let t1 = glyph.t1.f32()
    
        let sW = s1 - s0
        let sH = t1 - t0

        var x = pen_x + g_bearing_x
        var y = pen_y - g_bearing_y
        let w = g_width
        let h = g_height
        /*
        if (localWrap == FontWrap.word()) and (pen_y >= bounds_ymax) then
          break
        end
        */
        // if drawing this glyph will exceed the width of our draw box...
        let xCheck = (x + w)
        if xCheck >= bounds_xmax then
          if localWrap == FontWrap.word() then
            pen_x = end_of_word_pen_x
            i = start_of_word_index
          else
            i = i - 1
          end
          break
        end
                
        glyphRenderData.push(
          GlyphRenderData(x, y, w, h,
                          s0, t0, sW, sH
          )
        )
        
        pen_x = pen_x + g_advance_x
        
      end
    end
    
    glyphRenderData.truncate(i)
    
    (pen_x - start_pen._1, i - start_index)
  
  fun ref geometry( frameContext:FrameContext val, 
                    text:String, 
                    bounds:R4):Geometry =>
    """
    Generate a mesh for rendering the string. Wrap words before maxWidth is encountered
    TODO:
    - implement separable word wrapping and character wrapping (current it does character wrapping)
    - center vertically (ie like UILabel)
    """
    
    let geom = bufferedGeometry.next()
    if geom.check(frameContext, bounds) then
      return geom
    end
    
    needs_rendered = false
    
    let vertices = geom.vertices
    let indices = geom.indices
    
    // 4 vertices for each character, x,y,z,u,t
    vertices.reserve(text.size() * 4 * 5)
    vertices.clear()
  
    indices.reserve(text.size() * 6)
    indices.clear()
    
    glyphRenderData.reserve(text.size())
    glyphRenderData.clear()
    
    let fontAtlas = font.fontAtlas
    let advance_y = fontAtlas.height.f32() * fontSize
    
    let bounds_xmin = R4fun.x_min(bounds)
    let bounds_xmax = R4fun.x_max(bounds)
    let bounds_ymin = R4fun.y_min(bounds)
    let bounds_ymax = R4fun.y_max(bounds)
    
    
    let end_index:USize = text.size()
    var start_index:USize = 0
    var pen:V2 = V2fun(bounds_xmin, bounds_ymin + fontSize)
        
    // measure out all lines of text (each character saved to glyphRenderData)
    var idx:U32 = 0
    while start_index < end_index do
      
      if (pen._2 - advance_y) >= bounds_ymax then
        break
      end
      
      let start_glyph_idx = glyphRenderData.size()
      
      (let renderWidth, let next_index) = measureNextTextLine(text, start_index, pen, bounds)
      
      let x_off:F32 = (match fontAlignment
      | Alignment.left() => 0
      | Alignment.center() => ((bounds_xmax - bounds_xmin) - renderWidth) / 2.0
      | Alignment.right() => ((bounds_xmax - bounds_xmin) - renderWidth)
      else 0.0 end).max(0.0)

      
      // update each glyph in this line with the x_off
      if x_off != 0 then
        for g in glyphRenderData.valuesAfter(start_glyph_idx) do
          g.bx = g.bx + x_off
        end
      end
      
      pen = V2fun(pen._1, pen._2 + advance_y)
      
      start_index = start_index + next_index
    end
    
    let renderHeight = pen._2 - (bounds_ymin + fontSize)
    
    let y_off:F32 = (match fontVerticalAlignment
    | VerticalAlignment.top() => 0
    | VerticalAlignment.middle() => ((bounds_ymax - bounds_ymin) - renderHeight) / 2.0
    | VerticalAlignment.bottom() => ((bounds_ymax - bounds_ymin) - renderHeight)
    else 0.0 end).max(0.0)
            
    // commit all glyphs in glyphRenderData to geometry
    for g in glyphRenderData.values() do
    
      if (g.bw == 0) or (g.bh == 0) or (g.tw == 0) or (g.th == 0) then
          continue
      end
      
      var x_min = g.bx
      var x_max = g.bx + g.bw
      var y_min = g.by + y_off
      var y_max = g.by + g.bh + y_off
      
      var st_x_min = g.tx
      var st_x_max = g.tx + g.tw
      var st_y_min = g.ty
      var st_y_max = g.ty + g.th
      
      // Our text is allowed to extend outside of the bounds up until this point.
      // Now need to check to see if they need cropped, and then crop them
      let w_mod = if x_max >= bounds_xmax then
                    1.0 - ((x_max - bounds_xmax) / g.bw)
                  else
                    1.0
                  end
      let h_mod = if y_max >= bounds_ymax then
                    1.0 - ((y_max - bounds_ymax) / g.bh)
                  else
                    1.0
                  end
      
      
      x_max = g.bx + (g.bw * w_mod)
      y_max = g.by + y_off + (g.bh * h_mod)
      
      st_x_max = g.tx + (g.tw * w_mod)
      st_y_max = g.ty + (g.th * h_mod)
      
      if (x_max > x_min) and (y_max > y_min) then
        RenderPrimitive.buildVT(frameContext, vertices,   V3fun(x_min, y_min, 0.0),   V2fun(st_x_min, st_y_min) )
        RenderPrimitive.buildVT(frameContext, vertices,   V3fun(x_max, y_min, 0.0),   V2fun(st_x_max, st_y_min) )
        RenderPrimitive.buildVT(frameContext, vertices,   V3fun(x_max, y_max, 0.0),   V2fun(st_x_max, st_y_max) )
        RenderPrimitive.buildVT(frameContext, vertices,   V3fun(x_min, y_max, 0.0),   V2fun(st_x_min, st_y_max) )
      
        indices.push(idx + 0)
        indices.push(idx + 1)
        indices.push(idx + 2)
        indices.push(idx + 2)
        indices.push(idx + 3)
        indices.push(idx + 0)
  
        idx = idx + 4
      end
    end
    
    geom
    

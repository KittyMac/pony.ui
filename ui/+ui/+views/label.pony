use "linal"

actor Label is (Viewable & Colorable)
		  
  var value:String
  
  var font:Font
  var fontName:String
  
  var fontRender:FontRender
  	
  new empty() =>
    font = Font.empty()
    value = ""
    
    _color = RGBA.black()
    fontName = ""
    fontRender = FontRender.empty()
  
	new create(value':String, fontName':String, fontSize':F32 = 16) =>
    value = value'
    fontName = fontName'
    
    _color = RGBA.black()
    font = Font(fontName)
    fontRender = FontRender(font, fontSize', RGBA.black())
  
  be left() =>
    fontRender.fontAlignment = Alignment.left()
  be center() =>
    fontRender.fontAlignment = Alignment.center()
  be right() =>
    fontRender.fontAlignment = Alignment.right()
  
  be top() =>
    fontRender.fontVerticalAlignment = VerticalAlignment.top()
  be middle() =>
    fontRender.fontVerticalAlignment = VerticalAlignment.middle()
  be bottom() =>
    fontRender.fontVerticalAlignment = VerticalAlignment.bottom()
  
  be size(fontSize:F32) =>
    fontRender.fontSize = fontSize
  
	fun ref render(frameContext:FrameContext val, bounds:R4) =>
    fontRender.fontColor = _color
    let geom = fontRender.geometry(frameContext, value, bounds)
    RenderPrimitive.renderCachedGeometry(frameContext, 0, ShaderType.sdf(), geom.vertices, geom.indices, fontRender.fontColor, fontName.cpointer())

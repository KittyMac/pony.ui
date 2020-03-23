use "linal"

actor Color is (Viewable & Colorable)
				
  new empty() =>
    _color = RGBA.white()
  
	new create(color':RGBA) =>
		_color = color'
		
	fun ref render(frameContext:FrameContext val, bounds:R4) =>
    RenderPrimitive.renderColoredQuad(frameContext, 0, bounds, _color, RGBA.white())

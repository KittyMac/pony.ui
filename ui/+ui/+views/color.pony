use "linal"

actor Color is (Viewable & Colorable)
				
  new create() =>
    _color = RGBA.white()
		
	fun ref render(frameContext:FrameContext val, bounds:R4) =>
    RenderPrimitive.renderColoredQuad(frameContext, 0, bounds, _color, RGBA.white())

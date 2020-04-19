use "linal"
use "utility"

actor Label is Fontable
	var _color:RGBA val = RGBA.black()
  
  fun ref start(frameContext:FrameContext val) =>
    fontable_start(frameContext)
  
  fun ref render(frameContext:FrameContext val, bounds:R4) =>
    fontable_render(frameContext, bounds)
  
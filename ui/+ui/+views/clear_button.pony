use "linal"
use "stringext"

actor ClearButton is Buttonable
  """
  A button which has no visuals at all. You can use this to make invisible click areas wrapping other parts of your UI.

  Example:

  YogaNode.view( ClearButton.empty().>onClick({ 
    () =>
      @printf("clicked!\n".cstring())
    }) ).>width(200)
        .>height(60)
        .>addChildren([
      YogaNode.view( Color(RGBA.grey()) ).>fill()
      YogaNode.view( Label("Clear Tap Area", TestFontJson()) )
  ])
  """
  
  new empty() =>
    None
  
	new create() =>
    None
  
  fun ref updateButton(pressed:Bool) =>
    None

  fun ref event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
    buttonable_event(frameContext, anyEvent, bounds)
    
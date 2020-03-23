use "linal"
use "stringext"

actor ImageButton is (Imageable & Buttonable)
  """
  A button which toggles between two supplied images.

  Example:

  YogaNode.view( ImageButton( "unpressed_button", "pressed_button" ).>sizeToFit()
                                                                    .>onClick({ 
    () =>
      @printf("clicked 3!\n".cstring())
    }) )
  """

  var unpressedImage:String
  var pressedImage:String
  
  var _pressedColor:RGBA
  var _savedColor:RGBA
  
  new empty() =>
    unpressedImage = ""
    pressedImage = ""
    _pressedColor = RGBA.white()
    _savedColor = RGBA.white()
  
	new create(unpressedImage':String, pressedImage':String, pressedColor':RGBA = RGBA.white()) =>
    unpressedImage = unpressedImage'
    pressedImage = pressedImage'
    _pressedColor = pressedColor'
    _savedColor = pressedColor'
  
  be pressedColor(pressedColor':RGBA) =>
    _pressedColor = pressedColor'
  
  fun ref start(frameContext:FrameContext val) =>
    _textureName = unpressedImage
    imageable_start(frameContext)
  
  fun ref updateButton(pressed:Bool) =>
    if pressed then
      _textureName = pressedImage
      _savedColor = _color
      _color = _pressedColor
    else
      _textureName = unpressedImage
      _color = _savedColor
    end
    engine.setNeedsRendered()

  fun ref event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
    buttonable_event(frameContext, anyEvent, bounds)
  
  fun ref render(frameContext:FrameContext val, bounds:R4) =>
    imageable_render(frameContext, bounds)
  
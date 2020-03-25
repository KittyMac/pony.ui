use "linal"
use "stringext"

actor Button is Buttonable
  """
  A bare-bones button which relies on you (the UI developer) to YogaNodes which represent its pressed and unpressed states. These
  states are simply the first and second children of this button, and they are hidden or shown based on user events.
  
  Example:
  
  YogaNode.>width(100)
          .>height(100)
          .>view( Button.empty().>onClick({ () => @printf("clicked!\n".cstring()) }) )
          .>addChildren([
            YogaNode( Color(RGBA.red()) )  // Red when not pressed
            YogaNode( Color(RGBA.blue()) ) // Blue when pressed
          ])
  """

  new empty() =>
    None

  new create() =>
    None
  
  fun ref event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
    buttonable_event(frameContext, anyEvent, bounds)
  
  fun ref updateChildren(showChildIdx:USize, isStart:Bool = false) =>
    engine.getNodeByID(nodeID, { (node) =>
      var childIdx:USize = 0
      for child in node.children.values() do
        if showChildIdx == childIdx then
          child.>display(_YgdisplayEnum.flex())
        else
          child.>display(_YgdisplayEnum.none())
        end
        childIdx = childIdx + 1
      end
    
      if isStart then
        engine.startFinished()
      end
      true
    })
  
  fun ref start(frameContext:FrameContext val) =>
    updateChildren(0, true)
  
  fun ref updateButton(pressed:Bool) =>
    if pressed then
      updateChildren(1)
    else
      updateChildren(0)
    end
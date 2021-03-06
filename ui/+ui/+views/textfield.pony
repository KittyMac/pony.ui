use "linal"
use "utility"

actor TextField is (Fontable & Buttonable & Actionable & Syncable)
	var _color:RGBA val = RGBA.black()
  var focusable:Bool = true
  
  fun ref start(frameContext:FrameContext val) =>
    fontable_start(frameContext)

  fun ref event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
    buttonable_event(frameContext, anyEvent, bounds)
    
    if hasFocus(frameContext) then
      match anyEvent
      | let e:KeyEvent val =>
        if e.pressed then
          if e.delete() then
            _value = _value.trim(0, _value.size()-1)
          elseif e.enter() then
            performAction()
            releaseFocus()
          elseif e.tab() then
            advanceFocus()
          else
            _value = _value + (e.characters)
          end
          
          setNeedsRendered()
          
          updateSync(_value)
        end
      end
    end
  
  fun ref syncDidUpdate(value:SyncType val) =>
    _value = value.string()
    fontRender.invalidate()
    setNeedsRendered()
  
  fun ref performClick() =>
    clickedCallback()

  fun ref render(frameContext:FrameContext val, bounds:R4) =>
    fontable_render(frameContext, bounds)
  
  fun ref invalidate(frameContext:FrameContext val) =>
    fontable_invalidate(frameContext)

  fun ref finish() =>
    syncable_finish()
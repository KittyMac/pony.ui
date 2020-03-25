use "ttimer"
use "yoga"
use "linal"
use "stringext"
use "utility"

use @RenderEngine_init[RenderContextRef](engine:RenderEngine tag)
use @RenderEngine_destroy[None](ctx:RenderContextRef tag)

primitive RenderContext
type RenderContextRef is Pointer[RenderContext]

type GetYogaNodeCallback is {(YogaNode ref):Bool}


// Context passed to all views when they are told to render. It contains information
// used by the RenderPrimitive but isn't necessary for the view itself to worry about
class FrameContext
  var engine:RenderEngine tag
  var renderContext:RenderContextRef tag
  var frameNumber:U64
  var renderNumber:U64
  var matrix:M4
  var nodeID:YogaNodeID
  
  new ref create(engine':RenderEngine tag, renderContext':RenderContextRef tag, nodeID':YogaNodeID, frameNumber':U64, renderNumber':U64, matrix':M4) =>
    engine = engine'
    renderContext = renderContext'
    frameNumber = frameNumber'
    renderNumber = renderNumber'
    matrix = matrix'
    nodeID = nodeID'
  
  fun clone():FrameContext val =>
    recover val
      FrameContext(engine, renderContext, nodeID, frameNumber, renderNumber, matrix)
    end

actor@ RenderEngine
  """
  The render engine is responsible for sending "renderable chunks" across the FFI to the 3D engine
  one whatever platform we are on. A renderable chunk consists of
  1. all geometric data, already transformed and ready to render
  2. information regarding what shader it should be rendered with
  3. information regarding what textures should be active for its rendering
  
  For each frame of the rendering, the render engine is responsible for passing these 
  chunks across the FFI. Each chunk is tagged with a unique frame number. The frame
  number allows the Pony render engine and the platform render engine to run
  completely independently of each other.
  
  Each series of renderable chunks must end with the "end chunk", which lets the
  platform render engine know that all of the rendering for this frame has been
  completed.
  
  In our view hierarchy, the render engine can be seen as the "root" view under
  which all renderable views are placed. The render engine's bounds alway match
  the renderable area of the "window" it is in.
  
  The view hierarchy built using yoga nodes. Each yoga node has a View actor 
  associated with it. The render engine stores the entirety of the yoga
  hierarchy.
  
  This has the distinct advantage that when rendering needs to happen,
  the render engine can iterate quickly over all nodes and ask their
  actors to render themselves. The render engine then knows exactly how
  many actors it should expect to hear from to know that all rendering
  for this frame has been completed.
  
  View inherently know nothing about how they are laid out. They are
  simply told to render in a Rect, and they need to do that to the
  best of their ability.
  
  YogaNodes are responsible for supplying information about how their
  associated view should be laid out.
  """
  let renderContext:RenderContextRef tag
	let node:YogaNode
  
  var layoutNeeded:Bool = false
  var renderNeeded:Bool = false
  
  var frameNumber:U64 = 0
  var waitingOnViewsToRender:U64 = 0
  
  var variable_cpu_throttle:U64 = 25
  
  fun _tag():U32 => 2002
  fun _batch():U32 => 5_000_000
  fun _prioritiy():U32 => 999
  
  fun _final() =>
    @RenderEngine_destroy(renderContext)
  
  new empty() =>
    node = YogaNode
    renderContext = RenderContextRef
  
	new create() =>
    node = YogaNode
    renderContext = @RenderEngine_init(this)
  
  be addNode(yoga:YogaNode iso) =>
    node.addChild( consume yoga )
    
    // after we first add a node, we need to do an immediate layout and a fake render
    // (or views whose layout depends on the size of their content)
    let frameContext = FrameContext(this, renderContext, node.id(), 0, 0, M4fun.id())
    waitingOnViewsToRender = node.start(frameContext)
    
  
  be getNodeByID(id:YogaNodeID, callback:GetYogaNodeCallback val) =>
    layoutNeeded = node.getNodeByID(id, callback) or layoutNeeded
  
  be updateBounds(w:F32, h:F32) =>
  // update the size of my node to match the window, then relayout everything
    node.>width(w).>height(h)
    layout()
  
  fun ref increaseCPUThrottleValue() =>
    ifdef ios then
      variable_cpu_throttle = (variable_cpu_throttle * 2).min(50)
    else
      variable_cpu_throttle = (variable_cpu_throttle * 2).min(1200)
    end
    @ponyint_cpu_throttle(variable_cpu_throttle)
  
  fun ref decreaseCPUThrottleValue() =>
    variable_cpu_throttle = (variable_cpu_throttle / 2).max(5)
    @ponyint_cpu_throttle(variable_cpu_throttle)
    
  fun ref layout() =>
    layoutNeeded = false
    renderNeeded = true
    node.layout()
    
  be renderAll() =>
    // run through all yoga nodes and render their associated views
    // keep track of how many views were told to render so we can know when they're all done
    
    if layoutNeeded then
      layout()
    end
        
    if renderNeeded and (waitingOnViewsToRender == 0) then
      renderNeeded = false
      
      increaseCPUThrottleValue()
      
      frameNumber = frameNumber + 1
      
      let frameContext = FrameContext(this, renderContext, node.id(), frameNumber, 0, M4fun.id())
      waitingOnViewsToRender = node.render(frameContext)
      
    else
      decreaseCPUThrottleValue()
      
      @RenderEngine_render(renderContext, frameNumber, U64.max_value(), ShaderType.finished(), 0, UnsafePointer[U32], 0, UnsafePointer[F32], false, 1.0, 1.0, 1.0, 1.0, Pointer[U8])
    end
  
  be setNeedsRendered() =>
    renderNeeded = true
  
  be setNeedsLayout() =>
    layoutNeeded = true
  
  
  be startFinished() =>
    if waitingOnViewsToRender == 0 then
      Log.println("Error: startFinished called but waitingOnViewsToRender is 0")
    else
      waitingOnViewsToRender = waitingOnViewsToRender - 1
    end
  
  be renderFinished() =>
    if waitingOnViewsToRender == 0 then
      Log.println("Error: renderFinished called but waitingOnViewsToRender is 0")
    else
      waitingOnViewsToRender = waitingOnViewsToRender - 1
      if waitingOnViewsToRender == 0 then
        // When all of the views have rendered, THEN call finished
        @RenderEngine_render(renderContext, frameNumber, U64.max_value(), ShaderType.finished(), 0, UnsafePointer[U32], 0, UnsafePointer[F32], false, 1.0, 1.0, 1.0, 1.0, Pointer[U8])
      end
    end
  
  be touchEvent(id:USize, pressed:Bool, x:F32, y:F32) =>
    let frameContext = FrameContext(this, renderContext, node.id(), 0, 0, M4fun.id())
    node.event(frameContext, TouchEvent(id, pressed, x, y))
  

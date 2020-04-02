use "linal"

actor Color is (Viewable & Colorable)

  var bufferedGeometry:BufferedGeometry = BufferedGeometry
				
  new create() =>
    _color = RGBA.white()
		
	fun ref render(frameContext:FrameContext val, bounds:R4) =>
    let geom = bufferedGeometry.next()
    let vertices = geom.vertices
    let indices = geom.indices
  
    if geom.check(frameContext, bounds) == false then
      
      vertices.reserve(4 * 9)
      vertices.clear()
      indices.reserve(6)
      indices.clear()
      
      let x_min = R4fun.x_min(bounds)
      let y_min = R4fun.y_min(bounds)
      let x_max = R4fun.x_max(bounds)
      let y_max = R4fun.y_max(bounds)
      
      RenderPrimitive.buildVC(frameContext, vertices,   V3fun(x_min,  y_min,  0.0), _color)
      RenderPrimitive.buildVC(frameContext, vertices,   V3fun(x_max,  y_min,  0.0), _color)
      RenderPrimitive.buildVC(frameContext, vertices,   V3fun(x_max,  y_max,  0.0), _color)
      RenderPrimitive.buildVC(frameContext, vertices,   V3fun(x_min,  y_max,  0.0), _color)
          
      indices.push(0); indices.push(1); indices.push(2)
      indices.push(2); indices.push(3); indices.push(0)
    end
    
    RenderPrimitive.renderCachedGeometry(frameContext, 0, ShaderType.flat(), vertices, indices, RGBA.white(), Pointer[U8])

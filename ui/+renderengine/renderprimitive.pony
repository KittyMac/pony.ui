use "ttimer"
use "yoga"
use "linal"

use @RenderEngine_textureInfo[TextureInfo](ctx:RenderContextRef tag, textureName:Pointer[U8] tag, widthPtr:Pointer[F32], heightPtr:Pointer[F32])
use @RenderEngine_render[None]( ctx:RenderContextRef tag, 
                        frameNumber:U64, 
                       renderNumber:U64, 
                         shaderType:U32,
                         numIndices:U32,
                            indices:UnsafePointer[U32] tag,
                        numVertices:U32,
                           vertices:UnsafePointer[F32] tag, 
                         freeMemory:Bool, 
                            globalR:F32, 
                            globalG:F32, 
                            globalB:F32, 
                            globalA:F32, 
                        textureName:Pointer[U8] tag)

struct TextureInfo
  let image_width:U32 = 0
  let image_height:U32 = 0
  let texture_width:U32 = 0
  let texture_height:U32 = 0
    
primitive ShaderType
  fun finished():U32 => 0
  fun flat():U32 => 1
  fun textured():U32 => 2
  fun sdf():U32 => 3

primitive RenderPrimitive
  """
  Rendering actors can call this concurrently safely to submit geometry to the platform rendering engine
  """
  fun tag buildVCT(frameContext:FrameContext val, vertices:AlignedArray[F32], v:V3, c:RGBA, st:V2) =>
    let p = M4fun.mul_v3_point_3x4(frameContext.matrix, v)
    vertices.push(p._1); vertices.push(p._2); vertices.push(p._3)
    vertices.push(c.r); vertices.push(c.g); vertices.push(c.b); vertices.push(c.a)
    vertices.push(st._1); vertices.push(st._2)
  
  fun tag buildVC(frameContext:FrameContext val, vertices:AlignedArray[F32], v:V3, c:RGBA) =>
    let p = M4fun.mul_v3_point_3x4(frameContext.matrix, v)
    vertices.push(p._1); vertices.push(p._2); vertices.push(p._3)
    vertices.push(c.r); vertices.push(c.g); vertices.push(c.b); vertices.push(c.a)
    
  fun tag buildVT(frameContext:FrameContext val, vertices:AlignedArray[F32], v:V3, st:V2) =>
    let p = M4fun.mul_v3_point_3x4(frameContext.matrix, v)
    vertices.push(p._1); vertices.push(p._2); vertices.push(p._3)
    vertices.push(st._1); vertices.push(st._2)
    
  fun tag renderFinished(frameContext:FrameContext val) =>
    frameContext.engine.renderFinished()
  
  fun tag startFinished(frameContext:FrameContext val) =>
    frameContext.engine.startFinished()
  
  fun tag renderColoredQuad(frameContext:FrameContext val, partNum:U64, b:R4, c:RGBA, gc:RGBA) =>
    let x_min = R4fun.x_min(b)
    let y_min = R4fun.y_min(b)
    let x_max = R4fun.x_max(b)
    let y_max = R4fun.y_max(b)
      
    var vertices:AlignedArray[F32] = AlignedArray[F32](28)
    buildVC(frameContext, vertices,   V3fun(x_min,  y_min,  0.0), c)
    buildVC(frameContext, vertices,   V3fun(x_max,  y_min,  0.0), c)
    buildVC(frameContext, vertices,   V3fun(x_max,  y_max,  0.0), c)
    buildVC(frameContext, vertices,   V3fun(x_min,  y_max,  0.0), c)
      
    var indices:AlignedArray[U32] = AlignedArray[U32](6)
    indices.push(0)
    indices.push(1)
    indices.push(2)
    indices.push(2)
    indices.push(3)
    indices.push(0)
        
    @RenderEngine_render( frameContext.renderContext, 
                          frameContext.frameNumber, 
                          (frameContext.renderNumber * 100) + partNum,
                          ShaderType.flat(), 
                          indices.size().u32(), 
                          indices.cpointer(), 
                          vertices.size().u32(), 
                          vertices.cpointer(),
                          true,
                          gc.r, gc.g, gc.b, gc.a,
                          Pointer[U8])
    vertices.forget()
    indices.forget()
    
  fun tag renderColoredTexturedQuad(frameContext:FrameContext val, partNum:U64, b:R4, c:RGBA, gc:RGBA, t:Pointer[U8] tag) =>
    let x_min = R4fun.x_min(b)
    let y_min = R4fun.y_min(b)
    let x_max = R4fun.x_max(b)
    let y_max = R4fun.y_max(b)
    
    var vertices:AlignedArray[F32] = AlignedArray[F32](28)
    buildVCT(frameContext, vertices,   V3fun(x_min,  y_min, 0.0), c,   V2fun(0.0, 0.0) )
    buildVCT(frameContext, vertices,   V3fun(x_max,  y_min, 0.0), c,   V2fun(1.0, 0.0) )
    buildVCT(frameContext, vertices,   V3fun(x_max,  y_max, 0.0), c,   V2fun(1.0, 1.0) )
    buildVCT(frameContext, vertices,   V3fun(x_min,  y_max, 0.0), c,   V2fun(0.0, 1.0) )

    var indices:AlignedArray[U32] = AlignedArray[U32](6)
    indices.push(0)
    indices.push(1)
    indices.push(2)
    indices.push(2)
    indices.push(3)
    indices.push(0)

    @RenderEngine_render( frameContext.renderContext,
                          frameContext.frameNumber,
                          (frameContext.renderNumber * 100) + partNum,
                          ShaderType.textured(), 
                          indices.size().u32(), 
                          indices.cpointer(), 
                          vertices.size().u32(), 
                          vertices.cpointer(),
                          true,
                          gc.r, gc.g, gc.b, gc.a,
                          t)
    vertices.forget()
    indices.forget()
  
  fun tag renderCachedGeometry(frameContext:FrameContext val, partNum:U64, shaderType:U32, vertices:AlignedArray[F32], indices:AlignedArray[U32], gc:RGBA val, t:Pointer[U8] tag) =>
    @RenderEngine_render( frameContext.renderContext,
                          frameContext.frameNumber,
                          (frameContext.renderNumber * 100) + partNum,
                          shaderType, 
                          indices.size().u32(), 
                          indices.cpointer(), 
                          vertices.size().u32(), 
                          vertices.cpointer(),
                          false,
                          gc.r, gc.g, gc.b, gc.a,
                          t)
    
  
  




